#!/usr/bin/env bash
set -euo pipefail

# This script lives in /var/www/case_narrative; the Rails repo is ./code.
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/code" && pwd)"
cd "$APP_DIR"

export RAILS_ENV=production

echo "==> Updating case_narrative from origin/main"
git fetch origin main
git reset --hard FETCH_HEAD

echo "==> Updating Nginx site configuration"
NGINX_SITE=/etc/nginx/sites-enabled/case_narrative.conf
# Keep a temporary backup beside the live config. Its name starts with
# .case_narrative.conf.backup. and gets a random suffix; remove it after a
# successful reload, or restore it if validation or reload fails.
NGINX_BACKUP="$(sudo -n mktemp /etc/nginx/sites-enabled/.case_narrative.conf.backup.XXXXXX)"
sudo -n cp -p "$NGINX_SITE" "$NGINX_BACKUP"
sudo -n install -o root -g root -m 0644 "$APP_DIR/case_narrative.conf" "$NGINX_SITE"

if sudo -n nginx -t; then
  if sudo -n systemctl reload nginx; then
    sudo -n rm -f "$NGINX_BACKUP"
  else
    echo "==> Nginx reload failed; restoring previous site configuration"
    sudo -n cp -p "$NGINX_BACKUP" "$NGINX_SITE"
    sudo -n rm -f "$NGINX_BACKUP"
    exit 1
  fi
else
  echo "==> Nginx configuration is invalid; restoring previous site configuration"
  sudo -n cp -p "$NGINX_BACKUP" "$NGINX_SITE"
  sudo -n rm -f "$NGINX_BACKUP"
  exit 1
fi

echo "==> Updating mise"
mise self-update --yes

echo "==> Installing project tool versions and Ruby gems"
mise install
mise exec -- bundle config set --local deployment true
mise exec -- bundle config set --local without 'development test'
mise exec -- bundle install

echo "==> Installing JavaScript dependencies"
mise exec -- bun install --frozen-lockfile --production

echo "==> Migrating and compiling assets"
mise exec -- bundle exec rails db:migrate
mise exec -- bundle exec rails assets:precompile

echo "==> Restarting Passenger"
mkdir -p tmp
touch tmp/restart.txt

QUEUE_SERVICE=case_narrative-solid-queue.service
if systemctl cat "$QUEUE_SERVICE" >/dev/null 2>&1; then
  echo "==> Restarting Solid Queue"
  sudo -n systemctl restart "$QUEUE_SERVICE"
else
  echo "==> $QUEUE_SERVICE is not installed; skipping worker restart"
fi

echo "==> Deploy complete"
