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
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/mesh-llm.sh"

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

# --- Intel display GPU only (Type: GPU without Metal/Apple M/NVIDIA) MUST reject ---
INTEL_DISP="$(cat "${FIX}/gpu-intel-display.txt")"
assert 'echo "$INTEL_DISP" | grep -qi "Type: GPU"' "intel fixture contains Type: GPU bait"
assert 'echo "$INTEL_DISP" | grep -qi "Intel"' "intel fixture is Intel chipset"
assert '! echo "$INTEL_DISP" | grep -qiE "Metal Support: Metal|Apple M[0-9]|NVIDIA|GeForce"' "intel fixture lacks LLM signals"
assert '! classify_llm_gpu_from_text "$INTEL_DISP"' "intel display Type:GPU → LLM GPU no"
assert '! accept_full_setup_target no' "intel path: full_setup reject when no"
# Also: if someone mapped classify→flag incorrectly, gate stays closed
INTEL_LABEL="$(classify_llm_gpu_label "$INTEL_DISP")"
assert '[[ "$INTEL_LABEL" == "llm-gpu:no" ]]' "intel label is llm-gpu:no"
assert '! accept_full_setup_target "$INTEL_LABEL"' "accept_full_setup rejects llm-gpu:no from intel"

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

# --- Mesh-LLM pure helpers (shipped mesh-llm.sh) ---
HELP_MESH="$(cat "${FIX}/mesh-help-sample.txt")"
PORT_PARSED="$(parse_mesh_openai_port_from_text "$HELP_MESH")"
assert '[[ "$PORT_PARSED" == "9337" ]]' "parse default OpenAI port 9337 from help text"
BASE_U="$(mesh_openai_base_url 127.0.0.1 9337)"
assert '[[ "$BASE_U" == "http://127.0.0.1:9337/v1" ]]' "base URL contract /v1"

assert '[[ "$(classify_mesh_role yes yes yes)" == "server" ]]' "bin+endpoint+gpu → server"
assert '[[ "$(classify_mesh_role yes no yes)" == "server-capable" ]]' "bin+gpu no endpoint → server-capable"
assert '[[ "$(classify_mesh_role yes no no)" == "client-only" ]]' "bin no gpu → client-only"
assert '[[ "$(classify_mesh_role no no no)" == "unavailable" ]]' "no bin no endpoint → unavailable"
assert '[[ "$(classify_mesh_role no yes no)" == "server" ]]' "endpoint without local bin still server (remote mesh)"

assert 'mesh_can_consume server' "server can consume"
assert 'mesh_can_consume client-only' "client-only can consume"
assert '! mesh_can_consume unavailable' "unavailable cannot consume"
assert 'mesh_can_serve server-capable' "server-capable can serve"
assert '! mesh_can_serve client-only' "client-only cannot serve"

MODELS_OK="$(cat "${FIX}/mesh-models-ok.json")"
IDS="$(parse_openai_models_json "$MODELS_OK")"
assert 'echo "$IDS" | grep -qx example-model-a' "parse models json id a (live-shaped fixture)"
assert 'echo "$IDS" | grep -qx example-model-b' "parse models json id b"
assert '[[ "$(echo "$IDS" | grep -c .)" == "2" ]]' "exactly two ids from fixture (not hardcoded catalog)"

MODELS_EMPTY="$(cat "${FIX}/mesh-models-empty.json")"
IDS_E="$(parse_openai_models_json "$MODELS_EMPTY")"
assert '[[ -z "$(echo "$IDS_E" | tr -d "[:space:]")" ]]' "empty models list parses to no ids"

ENV_LINES="$(mesh_env_export_lines "http://127.0.0.1:9337/v1")"
assert 'echo "$ENV_LINES" | grep -q "OPENAI_BASE_URL=http://127.0.0.1:9337/v1"' "env export OPENAI_BASE_URL"

assert '! grep -R --include="*.sh" -nE "OFFICIAL_MODELS\s*=" "${KIT_ROOT}/scripts"' "no OFFICIAL_MODELS= in kit"
assert '! grep -R --include="*.sh" -nE "\"GLM-4.7|Qwen3-8B-Q4" "${KIT_ROOT}/scripts/lib/mesh-llm.sh"' "no frozen model names in mesh-llm.sh"

# Live mesh binary optional
export PATH="${HOME}/.local/bin:${PATH}"
MESH_LIVE="$(collect_mesh_facts yes 2>/dev/null || true)"
assert 'echo "$MESH_LIVE" | grep -q "^mesh_llm_binary="' "collect_mesh_facts emits binary key"
assert 'echo "$MESH_LIVE" | grep -q "^mesh_llm_role="' "collect_mesh_facts emits role"
assert 'echo "$MESH_LIVE" | grep -q "^mesh_llm_base_url="' "collect_mesh_facts emits base_url"
if command -v mesh-llm >/dev/null 2>&1; then
  assert 'echo "$MESH_LIVE" | grep -q "^mesh_llm_binary=yes"' "live mesh-llm binary present"
else
  echo "WARN: mesh-llm not installed — binary=no is honest"
  assert 'echo "$MESH_LIVE" | grep -q "^mesh_llm_binary=no"' "missing binary reported honestly"
fi

# --- herdr live if present ---
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