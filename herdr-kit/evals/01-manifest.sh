#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
test -f "$ROOT/herdr-plugin.toml"
grep -q 'tyler-jewell.herdr-kit' "$ROOT/herdr-plugin.toml"
grep -q 'id = "flash"' "$ROOT/herdr-plugin.toml"
grep -q 'id = "wipe"' "$ROOT/herdr-plugin.toml"
# no product UI plugins in desired list (comments ok if they forbid; ban plugin ids)
if grep -qiE 'id\s*=\s*".*herdr-web|"tyler-jewell\.herdr-web|official\.browser|chromium' \
  "$ROOT/config/plugins.desired.toml" 2>/dev/null; then
  echo "FAIL: product web/browser plugin in desired plugins"
  exit 1
fi
echo "PASS kit manifest"
