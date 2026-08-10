#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
grep -qi 'No secrets in git' "$ROOT/AGENTS.md"
echo "PASS no secrets policy"
