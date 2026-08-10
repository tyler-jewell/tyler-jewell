#!/usr/bin/env bash
# DO: umbrella AGENTS declares sacred LSP rule 13 (setup, public LSP, must-use, no suppressions, root cause).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$ROOT/AGENTS.md"
grep -q 'LSP setup and agent use' "$A"
grep -q 'public LSP' "$A"
grep -q 'MUST' "$A" && grep -qi 'LSP tools' "$A"
grep -qiE 'eslint-disable|# noqa|@ts-ignore|suppress' "$A"
grep -qi 'root cause' "$A"
# Root tree must declare its own languages + public LSP (Bash)
grep -qi 'Bash' "$A"
grep -qi 'bash-language-server' "$A"
# AXI expansion must not be nested under rule 13 only: principle table still under AXI
grep -q 'The 10 AXI principles' "$A"
# Ensure rule 13 is a top-level numbered item after rule 12, not only an indent blob
grep -E '^13\. \*\*LSP' "$A"
# DO NOT teach suppressions as default practice in umbrella
if grep -qiE 'prefer (eslint-disable|noqa|@ts-ignore)' "$A"; then
  echo "FAIL: docs prefer suppressions"
  exit 1
fi
echo "PASS sacred LSP policy present"
