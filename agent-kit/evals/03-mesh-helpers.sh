#!/usr/bin/env bash
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
test -f "$K/scripts/lib/mesh-llm.sh"
grep -q 'mesh_can_serve' "$K/scripts/lib/mesh-llm.sh"
echo "PASS mesh helpers"
