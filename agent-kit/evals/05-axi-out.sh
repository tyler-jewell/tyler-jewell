#!/usr/bin/env bash
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$K/scripts/lib/axi-out.sh"
[[ "$(axi_count 0)" == "count: 0" ]]
echo "PASS axi-out"
