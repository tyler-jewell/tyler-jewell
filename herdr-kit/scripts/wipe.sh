#!/usr/bin/env bash
# Graduated wipe. Default dry-run. Apply requires --apply --yes --level.
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"
# shellcheck source=lib/backup.sh
source "${KIT_ROOT}/scripts/lib/backup.sh"

APPLY=0
YES=0
LEVEL=""
PURGE_AUTH=0

usage() {
  cat <<EOF
wipe — graduated reset of agent/herdr state

USAGE
  wipe.sh --level soft|herdr|agents [--purge-auth] [--dry-run|--apply] [--yes]

LEVELS
  soft    Reset managed herdr config.toml to empty/minimal plan (keep plugins)
  herdr   Stop herdr server; backup; clear ~/.config/herdr runtime; uninstall kit plugin reg
  agents  herdr level + purge coding-agent user state under known runtime home dirs under ~/.grok (auth kept unless --purge-auth)

NEVER DELETES
  /nix, ~/system, ~/github-repos/tyler-jewell, ~/.ssh

DEFAULT
  dry-run (lists paths only)

Destructive apply requires: --apply --yes --level <level>
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    --dry-run) APPLY=0; shift ;;
    --apply) APPLY=1; shift ;;
    --yes) YES=1; shift ;;
    --level)
      LEVEL="${2:-}"
      shift 2
      ;;
    --purge-auth) PURGE_AUTH=1; shift ;;
    *)
      kit_error 2 "unknown flag: $1"
      kit_help "Run \`wipe.sh --help\`"
      exit 2
      ;;
  esac
done

if [[ -z "$LEVEL" ]]; then
  kit_error 2 "--level soft|herdr|agents required"
  kit_help "Example: wipe.sh --level soft"
  exit 2
fi

case "$LEVEL" in
  soft | herdr | agents) ;;
  *)
    kit_error 2 "invalid level: $LEVEL"
    exit 2
    ;;
esac

echo "bin: ${KIT_ROOT}/scripts/wipe.sh"
echo "mode: $([[ "$APPLY" -eq 1 ]] && echo apply || echo dry-run)"
echo "level: $LEVEL"
echo "purge_auth: $PURGE_AUTH"

paths=()
case "$LEVEL" in
  soft)
    paths+=("${HERDR_CONFIG_DIR}/config.toml")
    ;;
  herdr)
    paths+=(
      "${HERDR_CONFIG_DIR}/config.toml"
      "${HERDR_CONFIG_DIR}/plugins.json"
      "${HERDR_CONFIG_DIR}/herdr-server.log"
      "${HERDR_CONFIG_DIR}/herdr-client.log"
      "${HERDR_CONFIG_DIR}/session.json"
      "${HERDR_CONFIG_DIR}/plugins"
    )
    ;;
  agents)
    paths+=(
      "${HERDR_CONFIG_DIR}/config.toml"
      "${HERDR_CONFIG_DIR}/plugins.json"
      "${HERDR_CONFIG_DIR}/herdr-server.log"
      "${HERDR_CONFIG_DIR}/herdr-client.log"
      "${HERDR_CONFIG_DIR}/session.json"
      "${HERDR_CONFIG_DIR}/plugins"
      "${HOME}/.grok/sessions"
      "${HOME}/.grok/logs"
      "${HOME}/.grok/marketplace-cache"
      "${HOME}/.grok/hooks"
      "${HOME}/.grok/downloads"
    )
    if [[ "$PURGE_AUTH" -eq 1 ]]; then
      paths+=("${HOME}/.grok/auth.json" "${HOME}/.grok/auth.json.lock")
    fi
    ;;
esac

echo "targets:"
for p in "${paths[@]}"; do
  if kit_is_forbidden_wipe_path "$p"; then
    echo "  FORBIDDEN (skipped): $p"
    continue
  fi
  if [[ -e "$p" ]]; then
    echo "  remove: $p"
  else
    echo "  missing: $p"
  fi
done
echo "also_plan: herdr server stop (herdr|agents); plugin uninstall tyler-jewell.herdr-kit (herdr|agents)"
echo "never: /nix ~/system ~/github-repos/tyler-jewell ~/.ssh"

if [[ "$APPLY" -eq 0 ]]; then
  echo "result: dry-run (no writes)"
  kit_help "Apply: wipe.sh --level $LEVEL --apply --yes" "Then: bootstrap.sh --apply --yes"
  exit 0
fi

require_apply_yes "$APPLY" "$YES" "wipe level=$LEVEL" || exit 1

if [[ "$LEVEL" == "herdr" || "$LEVEL" == "agents" ]]; then
  if command -v herdr >/dev/null 2>&1; then
    herdr server stop 2>/dev/null || true
  fi
  kit_backup_herdr "pre-wipe-${LEVEL}" || true
fi

if [[ "$LEVEL" == "soft" ]]; then
  kit_backup_herdr "pre-wipe-soft" || true
  # Reset to desired minimal rather than empty
  mkdir -p "$HERDR_CONFIG_DIR"
  cp "$DESIRED_CONFIG" "${HERDR_CONFIG_DIR}/config.toml"
  echo "reset: config.toml ← desired"
elif [[ "$LEVEL" == "herdr" || "$LEVEL" == "agents" ]]; then
  if command -v herdr >/dev/null 2>&1; then
    herdr plugin uninstall tyler-jewell.herdr-kit 2>/dev/null || true
  fi
  for p in "${paths[@]}"; do
    if kit_is_forbidden_wipe_path "$p"; then
      continue
    fi
    # only under herdr config or .grok for agents
    case "$p" in
      "${HERDR_CONFIG_DIR}"/* | "${HOME}/.grok"/*) ;;
      *)
        echo "skip non-allowlisted: $p"
        continue
        ;;
    esac
    if [[ -e "$p" ]]; then
      rm -rf "$p"
      echo "removed: $p"
    fi
  done
fi

echo "result: wipe apply complete (level=$LEVEL)"
kit_help "Run \`bootstrap.sh --apply --yes\`" "Or \`cycle.sh --level $LEVEL --apply --yes\`"
exit 0
