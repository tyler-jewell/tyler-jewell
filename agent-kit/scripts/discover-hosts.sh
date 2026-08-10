#!/usr/bin/env bash
# Discover local host + network candidates (AXI-aligned).
# Full-setup serve requires LLM-capable GPU. Empty network is valid.
# Exit: 0 success, 1 error, 2 usage.
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/host-facts.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/gpu-classify.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/axi-out.sh"

JSON=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=1; shift ;;
    -h | --help)
      cat <<EOF
discover-hosts — local host facts + ssh network candidates

USAGE
  discover-hosts.sh [--json] [-h|--help]

NO-ARGS
  Live local facts + network candidates (content first).

OPTIONS
  --json   Emit JSON blob of local facts + ssh aliases
EOF
      exit 0
      ;;
    *)
      axi_error 2 "unknown flag: $1"
      axi_help "Run \`discover-hosts.sh --help\`"
      exit 2
      ;;
  esac
done

FACTS="$(collect_local_host_facts)"
SLUG="$(echo "$FACTS" | sed -n 's/^slug=//p')"
LLM="$(echo "$FACTS" | sed -n 's/^llm_gpu=//p')"
ELIG="$(echo "$FACTS" | sed -n 's/^full_setup_eligible=//p')"
OS_F="$(echo "$FACTS" | sed -n 's/^os=//p')"
ARCH="$(echo "$FACTS" | sed -n 's/^arch=//p')"
HOSTN="$(echo "$FACTS" | sed -n 's/^hostname=//p')"

cands=()
while IFS= read -r h; do
  [[ -n "$h" ]] && cands+=("$h")
done < <(list_ssh_config_hosts || true)
n="${#cands[@]}"

if [[ "$JSON" -eq 1 ]]; then
  export FACTS_BLOB="$FACTS"
  export CANDS="$(printf '%s\n' "${cands[@]+${cands[@]}}")"
  python3 - <<'PY'
import json, os
facts = {}
for line in os.environ.get("FACTS_BLOB", "").splitlines():
    if "=" in line:
        k, v = line.split("=", 1)
        facts[k] = v
cands = [c for c in os.environ.get("CANDS", "").split("\n") if c]
print(json.dumps({
    "local": facts,
    "ssh_candidates": cands,
    "require_llm_gpu": True,
    "count_ssh": len(cands),
}, indent=2))
PY
  exit 0
fi

axi_header "$SELF" "Local host facts and ssh network candidates (LLM-GPU full-setup gate)"
axi_count 1
axi_table host "slug,hostname,os,arch,llm_gpu,full_setup" \
  "${SLUG},${HOSTN},${OS_F},${ARCH},${LLM},${ELIG}"

if [[ "$n" -eq 0 ]]; then
  axi_empty "ssh_candidates"
else
  axi_count "$n"
  rows=()
  for h in "${cands[@]}"; do
    rows+=("${h},pending_gpu_probe")
  done
  axi_table ssh_candidates "alias,full_setup" "${rows[@]}"
fi

printf 'require_llm_gpu: yes\n'

axi_help \
  "Run \`agent-status.sh\` for mesh+herdr compact status" \
  "Run \`ai-first-setup.sh --dry-run\` for full kit verify" \
  "AXI: https://axi.md"

exit 0
