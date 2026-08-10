#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
grep -q 'Live CLI/API discovery' "$ROOT/AGENTS.md"
grep -q 'never hardcode' "$ROOT/AGENTS.md"
echo "PASS live discovery sacred"
