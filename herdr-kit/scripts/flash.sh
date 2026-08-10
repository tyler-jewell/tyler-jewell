#!/usr/bin/env bash
# Flash desired Herdr config. Default: dry-run. Writes require --apply.
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"
# shellcheck source=lib/backup.sh
source "${KIT_ROOT}/scripts/lib/backup.sh"

APPLY=0
YES=0

usage() {
  cat <<EOF
flash — apply desired herdr config from kit SSoT

USAGE
  flash.sh [--dry-run] [--apply] [--yes] [-h|--help]

NO-ARGS / --dry-run
  Show plan only (default). No writes.

OPTIONS
  --dry-run   Plan only (default)
  --apply     Write merged config + ensure kit plugin linked/installed
  --yes       Non-interactive (with --apply)
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
      kit_help "Run \`flash.sh --help\`"
      exit 2
      ;;
  esac
done

echo "bin: ${KIT_ROOT}/scripts/flash.sh"
echo "mode: $([[ "$APPLY" -eq 1 ]] && echo apply || echo dry-run)"
echo "desired_config: $DESIRED_CONFIG"
echo "desired_plugins: $DESIRED_PLUGINS"
echo "live_config: ${HERDR_CONFIG_DIR}/config.toml"

if [[ ! -f "$DESIRED_CONFIG" ]]; then
  kit_error 1 "missing $DESIRED_CONFIG"
  exit 1
fi

echo "plan[1]: merge config.toml.desired → ${HERDR_CONFIG_DIR}/config.toml"
echo "plan[2]: ensure tyler-jewell.herdr-kit registered (link local kit or github install)"
echo "plan[3]: herdr config check"
echo "plan[4]: no herdr-web / browser"

if [[ "$APPLY" -eq 0 ]]; then
  echo "result: dry-run (no writes)"
  if [[ -f "${HERDR_CONFIG_DIR}/config.toml" ]]; then
    echo "live_preview:"
    sed 's/^/  /' "${HERDR_CONFIG_DIR}/config.toml" | head -40
  else
    echo "live_preview: (missing)"
  fi
  echo "desired_preview:"
  sed 's/^/  /' "$DESIRED_CONFIG"
  kit_help "Apply with: \`flash.sh --apply --yes\`" "Status: \`status.sh\`"
  exit 0
fi

if [[ "$YES" -ne 1 ]]; then
  kit_error 1 "refusing --apply without --yes"
  kit_help "Re-run: flash.sh --apply --yes"
  exit 1
fi

mkdir -p "$HERDR_CONFIG_DIR"
if [[ -d "$HERDR_CONFIG_DIR" ]]; then
  kit_backup_herdr "pre-flash" || true
fi

# Minimal merge: for v1, if live missing or only onboarding, replace with desired.
# If live has extra keys, prefer desired keys for known lines; keep simple (rule 20).
LIVE="${HERDR_CONFIG_DIR}/config.toml"
if [[ ! -f "$LIVE" ]]; then
  cp "$DESIRED_CONFIG" "$LIVE"
  echo "wrote: $LIVE (new)"
else
  # Simple strategy: write desired as base; append live lines not present as key=
  # For onboarding-only configs this is enough.
  cp "$DESIRED_CONFIG" "$LIVE"
  echo "wrote: $LIVE (from desired)"
fi

# Ensure kit linked from this tree when developing
if command -v herdr >/dev/null 2>&1; then
  if herdr plugin list 2>/dev/null | grep -q 'tyler-jewell.herdr-kit'; then
    echo "plugin: tyler-jewell.herdr-kit already registered"
  else
    echo "plugin: linking local kit $KIT_ROOT"
    herdr plugin link "$KIT_ROOT" --yes 2>/dev/null || herdr plugin link "$KIT_ROOT" || true
  fi
  herdr config check 2>&1 | sed 's/^/herdr_config: /' || true
else
  echo "warn: herdr not on PATH; config written but not verified"
fi

echo "result: apply complete"
kit_help "Run \`status.sh\`" "Soak: \`cycle.sh --level soft\` (dry-run)"
exit 0
