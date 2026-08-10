#!/usr/bin/env bash
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
if grep -R --include='*.sh' -nE 'OFFICIAL_TARGETS\s*=' "$K/scripts"; then exit 1; fi
echo "PASS no OFFICIAL_TARGETS"
