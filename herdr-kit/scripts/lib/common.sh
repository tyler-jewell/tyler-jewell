# shellcheck shell=bash
# Shared helpers for herdr-kit scripts.
KIT_ROOT="${KIT_ROOT:-}"
if [[ -z "$KIT_ROOT" ]]; then
  KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi
UMBRELLA_ROOT="$(cd "${KIT_ROOT}/.." && pwd)"
HERDR_CONFIG_DIR="${HERDR_CONFIG_DIR:-${HOME}/.config/herdr}"
BACKUP_DIR="${HERDR_KIT_BACKUP_DIR:-${HOME}/.local/share/herdr-kit/backups}"
DESIRED_CONFIG="${KIT_ROOT}/config/config.toml.desired"
DESIRED_PLUGINS="${KIT_ROOT}/config/plugins.desired.toml"

kit_error() {
  local code="$1"
  shift
  echo "error:"
  echo "  code: $code"
  echo "  message: $*"
}

kit_help() {
  local i=1
  for line in "$@"; do
    echo "help[${i}]:"
    echo "  $line"
    i=$((i + 1))
  done
}

# Refuse paths we never delete
kit_is_forbidden_wipe_path() {
  local p="$1"
  case "$p" in
    /nix | /nix/* | "${HOME}/system" | "${HOME}/system"/* | \
    "${HOME}/github-repos/tyler-jewell" | "${HOME}/github-repos/tyler-jewell"/* | \
    "${HOME}/.ssh" | "${HOME}/.ssh"/*)
      return 0
      ;;
  esac
  return 1
}

require_apply_yes() {
  local apply="$1" yes="$2" what="$3"
  if [[ "$apply" -ne 1 ]]; then
    kit_error 1 "refusing $what without --apply (dry-run only)"
    kit_help "Re-run with --apply --yes after review"
    return 1
  fi
  if [[ "$yes" -ne 1 ]]; then
    kit_error 1 "refusing $what without --yes"
    kit_help "Destructive actions require --apply --yes"
    return 1
  fi
  return 0
}
