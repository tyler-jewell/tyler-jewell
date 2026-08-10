# shellcheck shell=bash
# Timestamped backup of Herdr config before wipe/flash apply.
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

kit_backup_herdr() {
  local stamp tag dest
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  tag="${1:-manual}"
  dest="${BACKUP_DIR}/herdr-${tag}-${stamp}.tar.gz"
  mkdir -p "$BACKUP_DIR"
  if [[ ! -d "$HERDR_CONFIG_DIR" ]]; then
    echo "backup: skip (no $HERDR_CONFIG_DIR)"
    return 0
  fi
  tar -czf "$dest" -C "$(dirname "$HERDR_CONFIG_DIR")" "$(basename "$HERDR_CONFIG_DIR")" 2>/dev/null || {
    echo "backup: warn failed to tar $HERDR_CONFIG_DIR" >&2
    return 1
  }
  echo "backup: $dest"
}
