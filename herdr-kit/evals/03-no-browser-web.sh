#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if grep -RniE 'herdr-web|official\.browser|chromium|HERDR_BROWSER' \
  "$ROOT/scripts" "$ROOT/config" "$ROOT/herdr-plugin.toml" 2>/dev/null \
  | grep -v 'no herdr-web' | grep -v 'No herdr-web' | grep -v 'no product'; then
  echo "FAIL: browser/web product references in kit core"
  exit 1
fi
echo "PASS no browser/web in kit core"
