#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
grep -q 'Mesh-LLM' "$ROOT/AGENTS.md"
grep -q '9337' "$ROOT/AGENTS.md"
echo "PASS mesh primary"
