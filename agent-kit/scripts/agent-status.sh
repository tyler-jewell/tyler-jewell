#!/usr/bin/env bash
# AXI-aligned agent status (https://axi.md) — primary agent-facing kit entrypoint.
# No-args: live host + mesh + herdr summary (content first).
# Exit: 0 success, 1 error, 2 usage/unknown flag.
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/host-facts.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/gpu-classify.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/mesh-llm.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/herdr-ops.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/axi-out.sh"

export PATH="${HOME}/.local/bin:${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh 2>/dev/null || true

FULL=0
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

usage() {
  cat <<EOF
agent-status — live host / GPU / mesh / herdr summary for agents (AXI)

USAGE
  agent-status.sh [--full] [-h|--help]

OPTIONS
  --full     Include longer herdr status sample (truncated unless needed)
  -h, --help This help

NO-ARGS
  Prints live compact status (content first). Never interactive.

AXI
  https://axi.md — owned surface targets 10/10 applicable principles.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --full) FULL=1; shift ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      axi_error 2 "unknown flag: $1"
      axi_help "Run \`agent-status.sh --help\`"
      exit 2
      ;;
  esac
done

# --- live collection ---
FACTS="$(collect_local_host_facts)"
SLUG="$(echo "$FACTS" | sed -n 's/^slug=//p')"
LLM_GPU="$(echo "$FACTS" | sed -n 's/^llm_gpu=//p')"
ELIGIBLE="$(echo "$FACTS" | sed -n 's/^full_setup_eligible=//p')"
OS_F="$(echo "$FACTS" | sed -n 's/^os=//p')"
ARCH_F="$(echo "$FACTS" | sed -n 's/^arch=//p')"

MESH="$(collect_mesh_facts "$LLM_GPU")"
MESH_ROLE="$(echo "$MESH" | sed -n 's/^mesh_llm_role=//p')"
MESH_SERVE="$(echo "$MESH" | sed -n 's/^mesh_llm_can_serve=//p')"
MESH_CONS="$(echo "$MESH" | sed -n 's/^mesh_llm_can_consume=//p')"
MESH_BASE="$(echo "$MESH" | sed -n 's/^mesh_llm_base_url=//p')"
MESH_BIN="$(echo "$MESH" | sed -n 's/^mesh_llm_binary=//p')"
MESH_EP="$(echo "$MESH" | sed -n 's/^mesh_llm_endpoint_ok=//p')"
MESH_N="$(echo "$MESH" | sed -n 's/^mesh_llm_models_live_count=//p')"

NET_N=0
while IFS= read -r _h; do
  [[ -n "$_h" ]] && NET_N=$((NET_N + 1))
done < <(list_ssh_config_hosts || true)

HERDR_CFG="missing"
HERDR_N=0
if command -v herdr >/dev/null 2>&1; then
  if herdr_config_check >/dev/null 2>&1; then
    HERDR_CFG="ok"
  else
    HERDR_CFG="fail"
  fi
  HERDR_STATUS="$(herdr_integration_status 2>/dev/null || true)"
  HERDR_N="$(echo "$HERDR_STATUS" | grep -c ':' || true)"
fi

# --- AXI output ---
axi_header "$SELF" "Live host, GPU, mesh, and herdr status for Tyler Jewell agents"
axi_count 1

axi_table host "slug,os,arch,llm_gpu,full_setup" \
  "${SLUG},${OS_F},${ARCH_F},${LLM_GPU},${ELIGIBLE}"

axi_table mesh "binary,endpoint_ok,role,can_serve,can_consume,models_count" \
  "${MESH_BIN},${MESH_EP},${MESH_ROLE},${MESH_SERVE},${MESH_CONS},${MESH_N}"

printf 'mesh_base_url: %s\n' "$MESH_BASE"

axi_table herdr "config,integrations_count" \
  "${HERDR_CFG},${HERDR_N}"

if [[ "$NET_N" -eq 0 ]]; then
  axi_empty "ssh_network_candidates"
else
  axi_count "$NET_N"
  printf 'ssh_network_candidates: %s\n' "$NET_N"
fi

if [[ "$FULL" -eq 1 && -n "${HERDR_STATUS:-}" ]]; then
  printf 'herdr_status_sample:\n'
  # truncate multi-line sample
  sample="$(echo "$HERDR_STATUS" | head -20)"
  while IFS= read -r line; do
    printf '  %s\n' "$(axi_truncate "$line" 120)"
  done <<<"$sample"
fi

axi_help \
  "Run \`discover-hosts.sh\` for network candidate detail" \
  "Run \`ai-first-setup.sh --dry-run\` for full kit verify" \
  "Set OPENAI_BASE_URL=${MESH_BASE} for mesh consumers" \
  "See https://axi.md and docs/axi/axi-scorecard.md"

exit 0
