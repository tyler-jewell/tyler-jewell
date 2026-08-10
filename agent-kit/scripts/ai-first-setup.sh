#!/usr/bin/env bash
# AI-first setup entry: discover → (approval) → herdr + herdr-kit verify.
# Default is --dry-run (no host-file writes, no mass installs).
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UMBRELLA="$(cd "${KIT_ROOT}/.." && pwd)"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/host-facts.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/gpu-classify.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/herdr-ops.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/mesh-llm.sh"
# shellcheck source=/dev/null
source "${KIT_ROOT}/scripts/lib/axi-out.sh"

export PATH="${HOME}/.local/bin:${HOME}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh 2>/dev/null || true

DRY_RUN=1
APPLY=0
YES=0
PROPOSE_HOST=0
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

usage() {
  cat <<'EOF'
ai-first-setup — discover host/GPU/mesh/herdr; optional apply (AXI-aligned)

USAGE
  ai-first-setup.sh [--dry-run] [--apply] [--yes] [--propose-host] [-h|--help]

NO-ARGS
  Same as --dry-run: live discovery + verify (content first). Never interactive.

OPTIONS
  --dry-run       Discover + verify only (default)
  --apply         Allow host proposal write after approval
  --yes           Non-interactive approval (mirrors ask_user_question YES)
  --propose-host  Write hosts/<slug>/ proposal (needs --apply)
  -h, --help      This help

AXI: https://axi.md · Prefer agent-status.sh for compact live status.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; APPLY=0; shift ;;
    --apply) APPLY=1; DRY_RUN=0; shift ;;
    --yes) YES=1; shift ;;
    --propose-host) PROPOSE_HOST=1; shift ;;
    -h | --help) usage; exit 0 ;;
    *)
      axi_error 2 "unknown flag: $1"
      axi_help "Run \`ai-first-setup.sh --help\`" "Run \`agent-status.sh\` for compact status"
      exit 2
      ;;
  esac
done

log() { printf '==> %s\n' "$*"; }
ok() { printf 'OK  %s\n' "$*"; }
warn() { printf 'WARN %s\n' "$*" >&2; }
err() { printf 'ERR %s\n' "$*" >&2; }

require_approval() {
  local what="$1"
  if [[ "$APPLY" -eq 1 && "$YES" -eq 1 ]]; then
    ok "approved via --yes: $what"
    return 0
  fi
  if [[ "$APPLY" -eq 1 && "$YES" -eq 0 ]]; then
    err "Refusing '$what' without approval. Re-run with --yes after ask_user_question, or use --dry-run."
    return 1
  fi
  return 0
}

# --- 0. Privileged floor check ---
log "Layer check: privileged floor (Nix)"
if ! command -v nix >/dev/null 2>&1; then
  err "Nix missing — human day-0 only:"
  err "  sudo ~/system/scripts/privileged-setup.sh"
  exit 1
fi
ok "nix present: $(nix --version 2>/dev/null | head -1)"

# --- 0b. Host runtime SSoT (always-on / restart services) — human must confirm ---
log "Host runtime policy (SSoT: \$HOME/system/host-runtime.toml)"
HR="${HOME}/system/host-runtime.toml"
if [[ -f "$HR" ]]; then
  echo "host_runtime_file: $HR"
  grep -E '^(always_on|restart_services_on_boot|confirmed_by|herdr|mesh_llm)' "$HR" 2>/dev/null | sed 's/^/  /' || true
  # also nested [policy] keys
  grep -E 'always_on|restart_services|confirmed_by' "$HR" 2>/dev/null | sed 's/^/  /' || true
  CB="$(grep -E '^confirmed_by\s*=' "$HR" 2>/dev/null | tail -1 | sed 's/.*=\s*"\?\([^"]*\)"\?/\1/' || true)"
  if [[ "${CB// /}" != "human" ]]; then
    warn "host-runtime not human-confirmed (confirmed_by=${CB:-missing})"
    echo "  REQUIRED human questions (do not invent answers):"
    echo "    1) Do you want this machine to always be on and active?"
    echo "    2) Do you want managed services to start after power outage / reboot / macOS update?"
    echo "  Write answers into: $HR  then: home-manager switch --flake \$HOME/system#mbp@darwin"
    echo "  Mirror (read-only after apply): \$HOME/.config/tyler-host/runtime.toml"
  else
    ok "host-runtime confirmed_by=human"
  fi
else
  warn "missing $HR — create from system template; ask human Q1 always_on Q2 restart_services"
fi

# --- 1. Discover local ---
log "Discover local host (live)"
FACTS="$(collect_local_host_facts)"
echo "$FACTS"
LLM_GPU="$(echo "$FACTS" | sed -n 's/^llm_gpu=//p')"
ELIGIBLE="$(echo "$FACTS" | sed -n 's/^full_setup_eligible=//p')"
SLUG="$(echo "$FACTS" | sed -n 's/^slug=//p')"
HOSTNAME_F="$(echo "$FACTS" | sed -n 's/^hostname=//p')"
USER_F="$(echo "$FACTS" | sed -n 's/^username=//p')"

if [[ "$ELIGIBLE" != "yes" ]]; then
  warn "Local host llm_gpu=${LLM_GPU} — not eligible as full-setup GPU target by gate"
else
  ok "Local host eligible for full-setup (llm_gpu=yes)"
fi

# --- 2. Network candidates ---
log "Network / SSH candidates"
"${KIT_ROOT}/scripts/discover-hosts.sh" | sed -n '/network candidates/,/full-setup acceptance/p' || true

# --- 3. Herdr pure primitives ---
log "Herdr config check (first-class CLI)"
if herdr_config_check; then
  ok "herdr config check"
else
  warn "herdr config check failed or herdr missing"
fi

log "Herdr integration status (live — no hard-coded targets)"
STATUS_OUT="$(herdr_integration_status 2>&1 || true)"
echo "$STATUS_OUT" | head -40
ROW_COUNT="$(echo "$STATUS_OUT" | grep -c ':' || true)"
ok "integration status lines≈${ROW_COUNT} (from live CLI)"

# Guard: kit source must not freeze target inventories (allow comments mentioning the ban)
if grep -R --include='*.sh' -nE 'OFFICIAL_TARGETS\s*=' "${KIT_ROOT}/scripts" 2>/dev/null \
  || grep -R --include='*.sh' -nE 'frozenset\(\s*\{|"pi",\s*"omp",\s*"claude"' "${KIT_ROOT}/scripts" 2>/dev/null; then
  err "kit scripts must not hardcode integration inventories"
  exit 1
fi
ok "agent-kit scripts: no frozen integration inventory"

# --- 4. Mesh-LLM (primary local/mesh OpenAI-compatible layer) ---
log "Mesh-LLM availability (primary LLM resource — live probe, no model catalog)"
MESH_FACTS="$(collect_mesh_facts "$LLM_GPU")"
echo "$MESH_FACTS"
MESH_ROLE="$(echo "$MESH_FACTS" | sed -n 's/^mesh_llm_role=//p')"
MESH_BIN="$(echo "$MESH_FACTS" | sed -n 's/^mesh_llm_binary=//p')"
MESH_EP="$(echo "$MESH_FACTS" | sed -n 's/^mesh_llm_endpoint_ok=//p')"
MESH_BASE="$(echo "$MESH_FACTS" | sed -n 's/^mesh_llm_base_url=//p')"
if [[ "$MESH_BIN" == "yes" ]]; then
  ok "mesh-llm on PATH"
else
  warn "mesh-llm binary missing — install via upstream (see mesh_llm_install_hint)"
  mesh_llm_install_hint | sed 's/^/  /'
fi
if [[ "$MESH_EP" == "yes" ]]; then
  ok "OpenAI-compatible endpoint up: ${MESH_BASE}"
else
  warn "endpoint not reachable at ${MESH_BASE} (start with: mesh-llm serve --auto)"
fi
ok "mesh role=${MESH_ROLE} (server|server-capable|client-peer|client-only|unavailable)"
echo "--- consumer env contract ---"
mesh_env_export_lines "$MESH_BASE" | sed 's/^/  /'

# Guard: no frozen model inventories in kit
if grep -R --include='*.sh' -nE 'OFFICIAL_MODELS\s*=' "${KIT_ROOT}/scripts" 2>/dev/null \
  || grep -R --include='*.sh' -nE 'MODEL_CATALOG\s*=' "${KIT_ROOT}/scripts" 2>/dev/null; then
  err "kit must not hardcode model inventories"
  exit 1
fi
ok "no frozen OFFICIAL_MODELS in agent-kit"

# --- 5. herdr-kit ---
log "herdr-kit frozen-target guard"
if herdr_kit_no_frozen_targets; then
  ok "herdr-kit no frozen targets"
else
  warn "herdr-kit guard failed or missing"
fi

# --- 6. Optional host proposal ---
if [[ "$PROPOSE_HOST" -eq 1 ]]; then
  require_approval "write hosts/${SLUG} proposal" || exit 1
  DEST="${UMBRELLA}/hosts/${SLUG}"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    err "internal: propose requires --apply"
    exit 1
  fi
  mkdir -p "$DEST"
  if [[ ! -f "$DEST/host.toml" ]]; then
    cat >"$DEST/host.toml" <<EOF
# Generated by agent-kit from live facts — review before commit. No secrets.
slug = "${SLUG}"
hostname = "${HOSTNAME_F}"
username = "${USER_F}"
os = "$(echo "$FACTS" | sed -n 's/^os=//p')"
arch = "$(echo "$FACTS" | sed -n 's/^arch=//p')"
home = "$(echo "$FACTS" | sed -n 's/^home=//p')"
llm_gpu = "${LLM_GPU}"
full_setup_eligible = "${ELIGIBLE}"
mesh_llm_role = "${MESH_ROLE}"
mesh_llm_base_url = "${MESH_BASE}"
role = "auto-proposed"
umbrella_local = "${UMBRELLA}"
EOF
    ok "wrote $DEST/host.toml"
  else
    ok "host.toml already exists at $DEST (left unchanged)"
  fi
  if [[ ! -f "$DEST/AGENTS.md" ]]; then
    cat >"$DEST/AGENTS.md" <<EOF
# Host: ${HOSTNAME_F} (slug: ${SLUG})

**Secondary** host charter. Umbrella sacred rules apply.

- User: \`${USER_F}\`
- LLM GPU (live at proposal): \`${LLM_GPU}\`
- Full-setup eligible: \`${ELIGIBLE}\`

Update this file when role/paths stabilize. Dual-write README.md.
EOF
    printf '# %s\n\nAuto-proposed host. See host.toml.\n' "$SLUG" >"$DEST/README.md"
    ok "dual-wrote AGENTS.md + README.md under $DEST"
  fi
fi

# --- 7. Studio path pointer ---
log "Studio / remote parity"
if [[ -d "${UMBRELLA}/hosts/mac-studio" ]]; then
  ok "hosts/mac-studio template present — see README for SSH apply"
else
  warn "mac-studio host template missing"
fi

# --- AXI summary (compact; principles 1–5, 8–9) ---
echo
axi_header "$SELF" "AI-first kit report (host, mesh, herdr) — Tyler Jewell"
MODE_S="$([[ "$APPLY" -eq 1 ]] && echo apply || echo dry-run)"
axi_count 1
axi_table report "mode,slug,llm_gpu,full_setup,mesh_role,mesh_binary,herdr" \
  "${MODE_S},${SLUG},${LLM_GPU},${ELIGIBLE},${MESH_ROLE},${MESH_BIN},$(herdr_bin >/dev/null 2>&1 && echo present || echo missing)"
printf 'mesh_base_url: %s\n' "${MESH_BASE}"
printf 'umbrella: %s\n' "$(axi_home_path "$UMBRELLA")"
axi_help \
  "Run \`agent-status.sh\` for compact AXI status" \
  "Run \`discover-hosts.sh\` for network candidates" \
  "Mutations: \`ai-first-setup.sh --apply --yes\` only after ask_user_question" \
  "Mesh install: upstream mesh-llm only — see mesh_llm_install_hint" \
  "AXI: https://axi.md · scorecard: docs/axi/axi-scorecard.md"
ok "ai-first-setup finished"
