#!/usr/bin/env bash
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$K/scripts/lib/gpu-classify.sh"
! classify_llm_gpu_from_text "Type: GPU"$'\n'"Intel Iris"
classify_llm_gpu_from_text "Metal Support: Metal 4"
echo "PASS gpu gate"
