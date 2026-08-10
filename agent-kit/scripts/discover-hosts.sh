#!/usr/bin/env bash
# Discover local host + network candidates. Full-setup requires LLM-capable GPU.
# Does not invent hosts. Empty network inventory is valid.
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/host-facts.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/gpu-classify.sh"

JSON=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=1; shift ;;
    -h|--help)
      echo "Usage: discover-hosts.sh [--json]"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

echo "=== local host (live) ==="
collect_local_host_facts
echo

# Network: ssh config aliases only for v1 (honest empty if none)
echo "=== network candidates (ssh config Host entries) ==="
mapfile_hosts=()
while IFS= read -r h; do
  [[ -n "$h" ]] && mapfile_hosts+=("$h")
done < <(list_ssh_config_hosts || true)

if [[ ${#mapfile_hosts[@]} -eq 0 ]]; then
  echo "(none — no Host entries in ~/.ssh/config or file missing)"
  echo "network_count=0"
else
  for h in "${mapfile_hosts[@]}"; do
    echo "candidate_ssh_alias=${h}"
    echo "  note: GPU eligibility requires live probe over SSH (not assumed)"
    echo "  full_setup_pending_probe=yes"
  done
  echo "network_count=${#mapfile_hosts[@]}"
fi

echo
echo "=== full-setup acceptance rule ==="
echo "require_llm_gpu=yes"
echo "local_full_setup_eligible=$(collect_local_host_facts | sed -n 's/^full_setup_eligible=//p')"

if [[ "$JSON" -eq 1 ]]; then
  # Minimal JSON for agents
  local_facts="$(collect_local_host_facts)"
  python3 - <<'PY' "$local_facts" "${mapfile_hosts[@]+${mapfile_hosts[@]}}"
import json,sys
facts={}
for line in sys.argv[1].splitlines():
    if "=" in line:
        k,v=line.split("=",1)
        facts[k]=v
hosts=sys.argv[2:]
print(json.dumps({"local":facts,"ssh_candidates":hosts,"require_llm_gpu":True}, indent=2))
PY
fi
