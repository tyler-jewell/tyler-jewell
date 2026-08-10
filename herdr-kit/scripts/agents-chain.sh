#!/usr/bin/env bash
# Print AGENTS.md chain outer→inner for a path (concat for injection).
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"

usage() {
  cat <<EOF
agents-chain — list or dump AGENTS.md chain (outer → inner)

USAGE
  agents-chain.sh [--dump] <path-under-umbrella>
  agents-chain.sh -h|--help

OPTIONS
  --dump   Concatenate full chain bodies (for injection)
  (default) List paths only via hierarchy-order

NO-ARGS
  Error exit 2 (path required).
EOF
}

DUMP=0
TARGET=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    --dump) DUMP=1; shift ;;
    -*)
      kit_error 2 "unknown flag: $1"
      kit_help "Run \`agents-chain.sh --help\`"
      exit 2
      ;;
    *)
      TARGET="$1"
      shift
      break
      ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  kit_error 2 "path required"
  kit_help "Run \`agents-chain.sh hosts/macbook-pro\`"
  exit 2
fi

HO="${UMBRELLA_ROOT}/scripts/hierarchy-order.sh"
if [[ ! -x "$HO" ]]; then
  kit_error 1 "hierarchy-order.sh missing under umbrella"
  exit 1
fi

if [[ "$DUMP" -eq 0 ]]; then
  bash "$HO" --raw "$TARGET"
  exit $?
fi

while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  echo
  echo "##### BEGIN $f"
  cat "$f"
  echo
  echo "##### END $f"
done < <(bash "$HO" --raw "$TARGET")
exit 0
