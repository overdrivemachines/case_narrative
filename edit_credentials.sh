#!/bin/sh

set -eu

# Allow the script to be invoked from anywhere while still using this app's
# Rails launcher and bundle.
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir"

if [ ! -x ./bin/rails ]; then
  echo "Error: ./bin/rails is missing or is not executable." >&2
  exit 1
fi

# Respect an editor selected by the caller. VS Code must wait for the file to
# close or Rails can finish before the credentials are saved.
if [ -z "${VISUAL:-}" ] && [ -z "${EDITOR:-}" ]; then
  if command -v code >/dev/null 2>&1; then
    EDITOR="code --wait"
  else
    EDITOR="vi"
  fi
  export EDITOR
fi

exec ./bin/rails credentials:edit "$@"
