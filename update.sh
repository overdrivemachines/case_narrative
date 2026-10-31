#!/usr/bin/env bash
set -euo pipefail

# This script lives in /var/www/case_narrative; the Rails repo is ./code.
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/code" && pwd)"
cd "$APP_DIR"

export RAILS_ENV=production

echo "==> Updating case_narrative from origin/main"
git fetch origin main
git reset --hard FETCH_HEAD

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
