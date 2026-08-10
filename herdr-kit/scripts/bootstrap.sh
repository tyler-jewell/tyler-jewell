#!/usr/bin/env bash
# Bootstrap kit + flash from SSoT. Default dry-run.
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"

APPLY=0
YES=0

usage() {
  cat <<EOF
bootstrap — reinstall herdr-kit from SSoT and flash desired config

USAGE
  bootstrap.sh [--dry-run|--apply] [--yes]

STEPS (apply)
  1. Require herdr on PATH (else print human install hint; exit 1)
  2. herdr plugin link local kit (dev) or install github path
  3. flash.sh --apply --yes
  4. status.sh

DEFAULT dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    --dry-run) APPLY=0; shift ;;
    --apply) APPLY=1; shift ;;
    --yes) YES=1; shift ;;
    *)
      kit_error 2 "unknown flag: $1"
      kit_help "Run \`bootstrap.sh --help\`"
      exit 2
      ;;
  esac
done

echo "bin: ${KIT_ROOT}/scripts/bootstrap.sh"
echo "mode: $([[ "$APPLY" -eq 1 ]] && echo apply || echo dry-run)"
echo "plan[1]: require herdr binary"
echo "plan[2]: plugin link $KIT_ROOT (or install tyler-jewell/tyler-jewell/herdr-kit)"
echo "plan[3]: flash --apply"
echo "plan[4]: status"
echo "plan[5]: coding-agent reinstall is HUMAN if missing (no curl installer here)"

if [[ "$APPLY" -eq 0 ]]; then
  echo "result: dry-run"
  kit_help "Apply: bootstrap.sh --apply --yes"
  exit 0
fi

require_apply_yes "$APPLY" "$YES" "bootstrap" || exit 1

if ! command -v herdr >/dev/null 2>&1; then
  kit_error 1 "herdr not on PATH"
  kit_help "Install Herdr from https://herdr.dev then re-run bootstrap" "Do not use ad-hoc curl if umbrella forbids it"
  exit 1
fi

if ! command -v grok >/dev/null 2>&1; then
  echo "warn: coding agent binary not on PATH — human must reinstall Grok (official installer), then re-run bootstrap if hooks needed"
fi

echo "link: $KIT_ROOT"
herdr plugin link "$KIT_ROOT" --yes 2>/dev/null || herdr plugin link "$KIT_ROOT"
bash "${KIT_ROOT}/scripts/flash.sh" --apply --yes
bash "${KIT_ROOT}/scripts/status.sh"
echo "result: bootstrap complete"
exit 0
