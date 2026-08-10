#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
out="$(bash "$ROOT/scripts/flash.sh" 2>&1)"
echo "$out" | grep -q 'dry-run'
echo "$out" | grep -q 'no writes\|result: dry-run'
# wipe without level should fail loud
if bash "$ROOT/scripts/wipe.sh" 2>/dev/null; then
  echo "FAIL: wipe without level should fail"
  exit 1
fi
# unknown flag exit 2
set +e
bash "$ROOT/scripts/status.sh" --nope >/dev/null 2>&1
rc=$?
set -e
test "$rc" -eq 2
echo "PASS dry-run default + axi flags"
