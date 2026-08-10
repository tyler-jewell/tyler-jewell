#!/usr/bin/env bash
# Mesh-LLM availability helpers — pure parse/classify + thin live probes.
# Primary local/mesh LLM resource: OpenAI-compatible API (default :9337/v1).
# No frozen model/peer inventories — live CLI/API discovery only.
# shellcheck shell=bash

# Upstream defaults (overridable via env; not a model catalog).
MESH_LLM_DEFAULT_PORT="${MESH_LLM_DEFAULT_PORT:-9337}"
MESH_LLM_DEFAULT_BASE_URL="${MESH_LLM_DEFAULT_BASE_URL:-http://127.0.0.1:${MESH_LLM_DEFAULT_PORT}/v1}"

# --- pure: parse port from mesh-llm help / docs-shaped text ---
# Looks for port 9337 or --port <n> / localhost:<n>/v1 patterns.
parse_mesh_openai_port_from_text() {
  local text="${1:-}"
  local p
  p="$(echo "$text" | sed -nE 's/.*localhost:([0-9]+)\/v1.*/\1/p' | head -1)"
  if [[ -n "$p" ]]; then
    echo "$p"
    return 0
  fi
  p="$(echo "$text" | sed -nE 's/.*--port[= ]+([0-9]+).*/\1/p' | head -1)"
  if [[ -n "$p" ]]; then
    echo "$p"
    return 0
  fi
  p="$(echo "$text" | sed -nE 's/.*port `?([0-9]{4,5})`?.*/\1/p' | head -1)"
  if [[ -n "$p" ]]; then
    echo "$p"
    return 0
  fi
  echo "$MESH_LLM_DEFAULT_PORT"
}

# Build OpenAI-compatible base URL for a host:port (no trailing path junk).
mesh_openai_base_url() {
  local host="${1:-127.0.0.1}"
  local port="${2:-$MESH_LLM_DEFAULT_PORT}"
  echo "http://${host}:${port}/v1"
}

# Env export lines consumers should use (portable; no secrets).
mesh_env_export_lines() {
  local base="${1:-$MESH_LLM_DEFAULT_BASE_URL}"
  # Strip accidental double /v1/v1
  base="${base%/}"
  case "$base" in
    */v1) ;;
    *) base="${base}/v1" ;;
  esac
  cat <<EOF
export OPENAI_BASE_URL=${base}
export OPENAI_API_BASE=${base}
# Optional alias used by some tools:
export MESH_LLM_BASE_URL=${base}
EOF
}

# Classify availability from probe facts (pure).
# Args: binary_present yes|no, endpoint_ok yes|no, gpu_eligible yes|no
# Prints one of: server | client-only | unavailable
classify_mesh_role() {
  local bin="${1:-no}"
  local ep="${2:-no}"
  local gpu="${3:-no}"
  if [[ "$ep" == "yes" ]]; then
    echo "server"
    return 0
  fi
  if [[ "$bin" == "yes" && "$gpu" == "yes" ]]; then
    echo "server-capable"
    return 0
  fi
  if [[ "$bin" == "yes" ]]; then
    echo "client-only"
    return 0
  fi
  # No binary: still a mesh *client* via any OpenAI client if a peer serves /v1
  if [[ "$ep" == "yes" ]]; then
    echo "server"
    return 0
  fi
  echo "unavailable"
}

# True if role can consume OpenAI-compatible mesh API (local or remote).
mesh_can_consume() {
  local role="${1:-unavailable}"
  case "$role" in
    server|server-capable|client-only) return 0 ;;
    *) return 1 ;;
  esac
}

# True if role may start mesh-llm serve on this host (needs binary + GPU gate).
mesh_can_serve() {
  local role="${1:-unavailable}"
  case "$role" in
    server|server-capable) return 0 ;;
    *) return 1 ;;
  esac
}

# Parse OpenAI /v1/models JSON → model ids (one per line). Pure.
# Does not hardcode expected names.
parse_openai_models_json() {
  local json="${1:-}"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c '
import json,sys
raw=sys.stdin.read()
try:
    d=json.loads(raw)
except Exception:
    sys.exit(0)
data=d.get("data") or d.get("models") or []
if isinstance(data, list):
    for m in data:
        if isinstance(m, dict) and m.get("id"):
            print(m["id"])
        elif isinstance(m, str):
            print(m)
' <<<"$json" 2>/dev/null || true
  else
    # minimal fallback: "id":"..."
    echo "$json" | sed -nE 's/.*"id"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p'
  fi
}

# Detect mesh-llm binary on PATH (live).
mesh_llm_bin() {
  command -v mesh-llm 2>/dev/null || true
}

# Live: binary present?
mesh_llm_binary_present() {
  [[ -n "$(mesh_llm_bin)" ]]
}

# Live: probe OpenAI /v1/models (default base URL or arg).
# Prints JSON body on success (exit 0); else non-zero.
mesh_probe_v1_models() {
  local base="${1:-$MESH_LLM_DEFAULT_BASE_URL}"
  base="${base%/}"
  local url="${base}/models"
  if ! command -v curl >/dev/null 2>&1; then
    return 127
  fi
  curl -fsS --connect-timeout 2 --max-time 5 "$url" 2>/dev/null
}

# Live: is endpoint healthy enough to list models?
mesh_endpoint_ok() {
  local base="${1:-$MESH_LLM_DEFAULT_BASE_URL}"
  local body
  if body="$(mesh_probe_v1_models "$base")"; then
    # Accept empty list as "up" if valid JSON object
    if echo "$body" | grep -q '{'; then
      return 0
    fi
  fi
  return 1
}

# Collect mesh status key=value for agent-kit report.
# Args: llm_gpu yes|no (from existing GPU gate)
collect_mesh_facts() {
  local gpu="${1:-no}"
  local bin="no" ep="no" role body nmodels=0
  local base="$MESH_LLM_DEFAULT_BASE_URL"
  local port="$MESH_LLM_DEFAULT_PORT"
  local help=""

  if mesh_llm_binary_present; then
    bin="yes"
    help="$("$(mesh_llm_bin)" --help 2>&1 || true)"
    if [[ -n "$help" ]]; then
      port="$(parse_mesh_openai_port_from_text "$help")"
      base="$(mesh_openai_base_url 127.0.0.1 "$port")"
    fi
  fi

  if body="$(mesh_probe_v1_models "$base" 2>/dev/null)"; then
    ep="yes"
    nmodels="$(parse_openai_models_json "$body" | grep -c . || true)"
  fi

  role="$(classify_mesh_role "$bin" "$ep" "$gpu")"

  cat <<EOF
mesh_llm_binary=${bin}
mesh_llm_endpoint_ok=${ep}
mesh_llm_role=${role}
mesh_llm_base_url=${base}
mesh_llm_port=${port}
mesh_llm_models_live_count=${nmodels}
mesh_llm_can_serve=$(mesh_can_serve "$role" && echo yes || echo no)
mesh_llm_can_consume=$(mesh_can_consume "$role" && echo yes || echo no)
mesh_llm_primary=yes
EOF
}

# Upstream install pointer only — does not reimplement Mesh install.
mesh_llm_install_hint() {
  cat <<'EOF'
# Upstream Mesh-LLM install (human / approved once — not reimplemented here):
#   curl -fsSL https://raw.githubusercontent.com/Mesh-LLM/mesh-llm/main/install.sh | bash
#   # or: brew install Mesh-LLM/tap/mesh-llm
# Then:
#   mesh-llm setup
#   mesh-llm serve --auto          # node with GPU
#   mesh-llm client --auto         # API client without serving
# OpenAI-compatible API default: http://127.0.0.1:9337/v1
# Docs: https://github.com/Mesh-LLM/mesh-llm
EOF
}
