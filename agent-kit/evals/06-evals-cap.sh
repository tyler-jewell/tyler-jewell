#!/usr/bin/env bash
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
n=0
for f in "$K"/evals/[0-9][0-9]-*.sh; do [[ -e "$f" ]] || continue; n=$((n+1)); done
test "$n" -le 10
echo "PASS kit evals count=$n"
