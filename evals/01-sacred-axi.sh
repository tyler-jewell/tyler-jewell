#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
grep -q 'axi.md' "$ROOT/AGENTS.md"
grep -q 'AXI alignment' "$ROOT/AGENTS.md"
echo "PASS sacred AXI"
