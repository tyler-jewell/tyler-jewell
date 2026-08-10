#!/usr/bin/env bash
# DO: umbrella AGENTS declares sacred LSP rule 13 (setup, public LSP, must-use, no suppressions, root cause).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$ROOT/AGENTS.md"
grep -q 'LSP setup and agent use' "$A"
grep -q 'public LSP' "$A"
grep -qi 'MUST.*use available LSP\|MUST\*\* use available LSP\|agents \*\*MUST\*\* use available LSP' "$A" \
  || grep -q 'MUST' "$A" && grep -qi 'LSP tools' "$A"
grep -qiE 'eslint-disable|# noqa|@ts-ignore|suppress' "$A"
grep -qi 'root cause' "$A"
# DO NOT teach suppressions as default practice in umbrella
if grep -qiE 'prefer (eslint-disable|noqa|@ts-ignore)' "$A"; then
  echo "FAIL: docs prefer suppressions"
  exit 1
fi
echo "PASS sacred LSP policy present"
