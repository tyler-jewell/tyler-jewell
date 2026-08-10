#!/usr/bin/env bash
# Unit tests for shipped gpu-classify + host parsers + herdr-ops guards.
# Drives real library functions (not reimplemented).
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIX="${KIT_ROOT}/test/fixtures"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/gpu-classify.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/host-facts.sh"

pass=0
fail=0
assert() {
  if eval "$1"; then
    echo "PASS: $2"
    pass=$((pass + 1))
  else
    echo "FAIL: $2"
    fail=$((fail + 1))
  fi
}

# --- GPU gate: accept Metal/Apple ---
APPLE_GPU="$(cat "${FIX}/gpu-apple-metal.txt")"
assert 'classify_llm_gpu_from_text "$APPLE_GPU"' "apple metal → LLM GPU yes"
assert 'accept_full_setup_target yes' "accept full-setup when yes"

# --- GPU gate: accept NVIDIA ---
NV_GPU="$(cat "${FIX}/gpu-nvidia-ok.txt")"
assert 'classify_llm_gpu_from_text "$NV_GPU"' "nvidia-smi → LLM GPU yes"

# --- GPU gate: reject empty / CPU-only ---
CPU_ONLY="$(cat "${FIX}/gpu-none.txt")"
assert '! classify_llm_gpu_from_text "$CPU_ONLY"' "no GPU text → reject"
assert '! accept_full_setup_target no' "reject full-setup when no"
assert '! accept_full_setup_target llm-gpu:no' "reject llm-gpu:no"

# --- NVIDIA failed init ---
NV_FAIL="$(cat "${FIX}/gpu-nvidia-fail.txt")"
assert '! classify_llm_gpu_from_text "$NV_FAIL"' "nvidia failed → reject"

# --- SSH config parse (pure) ---
SSH_FIX="$(cat "${FIX}/ssh-config.txt")"
HOSTS="$(parse_ssh_config_hosts "$SSH_FIX")"
assert 'echo "$HOSTS" | grep -qx studio' "ssh parse studio"
assert 'echo "$HOSTS" | grep -qx gpu-box' "ssh parse gpu-box"
assert '! echo "$HOSTS" | grep -q "\*"' "ssh parse skips wildcard"

# --- Live local facts include llm_gpu key ---
FACTS="$(collect_local_host_facts)"
assert 'echo "$FACTS" | grep -q "^llm_gpu="' "live facts have llm_gpu"
assert 'echo "$FACTS" | grep -q "^full_setup_eligible="' "live facts have full_setup_eligible"
assert 'echo "$FACTS" | grep -q "^slug="' "live facts have slug"

# --- No hard-coded integration lists in kit ---
assert '! grep -R --include="*.sh" -nE "OFFICIAL_TARGETS\s*=" "${KIT_ROOT}/scripts"' "no OFFICIAL_TARGETS= in kit"
assert '! grep -R --include="*.sh" -nE "\"pi\",[[:space:]]*\"omp\",[[:space:]]*\"claude\"" "${KIT_ROOT}/scripts"' "no frozen pi/omp/claude list in kit"

# --- herdr live if present ---
export PATH="${HOME}/.local/bin:${PATH}"
if command -v herdr >/dev/null 2>&1; then
  # shellcheck source=/dev/null
  source "${KIT_ROOT}/scripts/lib/herdr-ops.sh"
  OUT="$(herdr_integration_status 2>&1 || true)"
  assert 'echo "$OUT" | grep -q ":"' "live herdr integration status has lines"
  assert 'herdr_web_no_frozen_targets' "herdr-web no OFFICIAL_TARGETS"
else
  echo "WARN: herdr missing — skipped live herdr asserts"
fi

echo
echo "Results: ${pass} passed, ${fail} failed"
[[ "$fail" -eq 0 ]]
