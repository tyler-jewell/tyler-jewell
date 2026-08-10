#!/usr/bin/env bash
# List/run kit evals + optional umbrella evals.
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"

CMD="${1:-list}"
shift || true

usage() {
  cat <<EOF
evals — kit (+ umbrella) compliance

USAGE
  evals.sh list|run [-h|--help]
EOF
}

case "$CMD" in
  -h | --help) usage; exit 0 ;;
  list | run) ;;
  *)
    kit_error 2 "unknown command: $CMD"
    kit_help "evals.sh list|run"
    exit 2
    ;;
esac

run_one() {
  local f="$1"
  echo "--- $(basename "$f")"
  bash "$f"
}

if [[ "$CMD" == "list" ]]; then
  n=0
  for f in "${KIT_ROOT}"/evals/[0-9][0-9]-*.sh; do
    [[ -e "$f" ]] || continue
    echo "$(basename "$f")"
    n=$((n + 1))
  done
  echo "count: $n"
  exit 0
fi

fail=0
for f in "${KIT_ROOT}"/evals/[0-9][0-9]-*.sh; do
  [[ -e "$f" ]] || continue
  if ! run_one "$f"; then
    fail=$((fail + 1))
  fi
done
# umbrella if present
if [[ -x "${UMBRELLA_ROOT}/evals/run.sh" ]]; then
  echo "==> umbrella evals"
  bash "${UMBRELLA_ROOT}/evals/run.sh" run || fail=$((fail + 1))
fi
echo "fail: $fail"
exit "$fail"
