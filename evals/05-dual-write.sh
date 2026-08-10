#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
grep -q 'Dual-write' "$ROOT/AGENTS.md"
test -f "$ROOT/README.md"
test -f "$ROOT/AGENTS.md"
echo "PASS dual-write root"
