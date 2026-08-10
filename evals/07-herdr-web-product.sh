#!/usr/bin/env bash
# DO: methodology points at herdr-web as shared isolatable product
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
grep -qi 'herdr-web' "$ROOT/README.md"
echo "PASS herdr-web referenced"
