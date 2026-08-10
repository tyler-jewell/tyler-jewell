#!/usr/bin/env bash
# DO NOT reintroduce product web UI or browser chrome in kit core.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if grep -RniE 'tyler-jewell\.herdr-web|github\.com/tyler-jewell/herdr-web|official\.browser|HERDR_BROWSER' \
  "$ROOT/scripts" "$ROOT/config" "$ROOT/herdr-plugin.toml" 2>/dev/null; then
  echo "FAIL: product web/browser references in kit core"
  exit 1
fi
echo "PASS no product web/browser in kit core"
