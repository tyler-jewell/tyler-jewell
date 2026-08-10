#!/usr/bin/env bash
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
test -f "$K/scripts/agent-status.sh"
grep -q 'axi.md\|AXI' "$K/scripts/agent-status.sh" || grep -q 'axi-out' "$K/scripts/agent-status.sh"
echo "PASS agent-status"
