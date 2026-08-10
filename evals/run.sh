#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
cmd="${1:-list}"
case "$cmd" in
  list)
    n=0
    for f in "$DIR"/[0-9][0-9]-*.sh; do [[ -e "$f" ]] || continue; n=$((n+1)); echo "$(basename "$f")"; done
    echo "count: $n"
    test "$n" -le 10
    ;;
  run)
    fail=0; n=0
    for f in "$DIR"/[0-9][0-9]-*.sh; do
      [[ -e "$f" ]] || continue
      n=$((n+1))
      bash "$f" || fail=$((fail+1))
    done
    echo "ran=$n fail=$fail"
    test "$fail" -eq 0
    ;;
  *) echo "usage: run.sh list|run"; exit 2 ;;
esac
