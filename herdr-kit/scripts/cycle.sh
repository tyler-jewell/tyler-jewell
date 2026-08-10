#!/usr/bin/env bash
# wipe → bootstrap → status. Default dry-run.
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"

APPLY=0
YES=0
LEVEL="soft"
PURGE_AUTH=0

usage() {
  cat <<EOF
cycle — wipe then bootstrap (soak helper)

USAGE
  cycle.sh --level soft|herdr|agents [--purge-auth] [--dry-run|--apply] [--yes]

DEFAULT
  dry-run, level soft
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
      kit_help "Run \`cycle.sh --help\`"
      exit 2
      ;;
  esac
done

case "$LEVEL" in
  soft | herdr | agents) ;;
  *)
    kit_error 2 "invalid --level"
    exit 2
    ;;
esac

echo "bin: ${KIT_ROOT}/scripts/cycle.sh"
echo "mode: $([[ "$APPLY" -eq 1 ]] && echo apply || echo dry-run)"
echo "level: $LEVEL"

WIPE_ARGS=(--level "$LEVEL")
[[ "$PURGE_AUTH" -eq 1 ]] && WIPE_ARGS+=(--purge-auth)
BOOT_ARGS=()
if [[ "$APPLY" -eq 1 ]]; then
  WIPE_ARGS+=(--apply --yes)
  BOOT_ARGS+=(--apply --yes)
else
  WIPE_ARGS+=(--dry-run)
  BOOT_ARGS+=(--dry-run)
fi

bash "${KIT_ROOT}/scripts/wipe.sh" "${WIPE_ARGS[@]}"
bash "${KIT_ROOT}/scripts/bootstrap.sh" "${BOOT_ARGS[@]}"

# Append soak log when applying
if [[ "$APPLY" -eq 1 ]]; then
  LOG="${UMBRELLA_ROOT}/hosts/macbook-pro/soak-log.md"
  mkdir -p "$(dirname "$LOG")"
  if [[ ! -f "$LOG" ]]; then
    cat >"$LOG" <<'EOF'
# MacBook Pro soak log

No secrets. Record wipe→bootstrap cycles before multi-host migration.

| UTC | Level | Purge auth | Result | Notes |
|-----|-------|------------|--------|-------|
EOF
  fi
  stamp="$(date -u +%Y-%m-%dT%H:%MZ)"
  echo "| $stamp | $LEVEL | $PURGE_AUTH | ok | cycle.sh apply |" >>"$LOG"
  echo "soak_log: $LOG"
fi

echo "result: cycle complete"
exit 0
