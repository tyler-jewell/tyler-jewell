#!/usr/bin/env bash
# Emit sacred umbrella AGENTS.md (delegates to umbrella script when present).
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"

usage() {
  cat <<EOF
pipe-agents — print sacred tyler-jewell AGENTS.md

USAGE
  pipe-agents.sh [-h|--help]
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    *)
      kit_error 2 "unknown flag: $1"
      kit_help "Run \`pipe-agents.sh --help\`"
      exit 2
      ;;
  esac
done

UP="${UMBRELLA_ROOT}/scripts/pipe-agents.sh"
if [[ -x "$UP" ]]; then
  exec bash "$UP"
fi
if [[ -f "${UMBRELLA_ROOT}/AGENTS.md" ]]; then
  cat "${UMBRELLA_ROOT}/AGENTS.md"
  exit 0
fi
kit_error 1 "umbrella AGENTS.md not found at $UMBRELLA_ROOT"
exit 1
