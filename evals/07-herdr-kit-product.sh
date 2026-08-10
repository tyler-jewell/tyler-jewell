#!/usr/bin/env bash
# DO: methodology points at herdr-kit as isolatable Herdr surface (no product web UI)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
test -d "$ROOT/herdr-kit"
test -f "$ROOT/herdr-kit/herdr-plugin.toml"
grep -qi 'herdr-kit' "$ROOT/README.md"
grep -qi 'herdr-kit' "$ROOT/AGENTS.md"
# DON'T reintroduce herdr-web product under this umbrella
if grep -qiE 'herdr-web|tyler-jewell/herdr-web' "$ROOT/README.md" "$ROOT/AGENTS.md" 2>/dev/null; then
  echo "FAIL: herdr-web still referenced in umbrella README/AGENTS"
  exit 1
fi
echo "PASS herdr-kit product surface (no herdr-web)"
