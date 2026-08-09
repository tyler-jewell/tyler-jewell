#!/usr/bin/env bash
# List AGENTS.md files from umbrella root → target path (outer → inner).
# Authoritative chain for Tyler Jewell: umbrella first, then specialization.
#
# Usage: hierarchy-order.sh <path>
#   path may be absolute or relative to CWD; must lie under the umbrella repo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "Usage: $0 <path-under-umbrella>" >&2
  exit 2
}

[[ $# -ge 1 ]] || usage
TARGET="$1"

# Resolve target to absolute path.
if [[ "$TARGET" != /* ]]; then
  TARGET="$(cd "$(dirname "$TARGET")" 2>/dev/null && pwd)/$(basename "$TARGET")"
fi
if [[ -d "$TARGET" ]]; then
  TARGET="$(cd "$TARGET" && pwd)"
elif [[ -e "$TARGET" ]]; then
  TARGET="$(cd "$(dirname "$TARGET")" && pwd)"
else
  echo "ERR: path not found: $1" >&2
  exit 1
fi

case "$TARGET" in
  "$ROOT"|"$ROOT"/*) ;;
  *)
    echo "ERR: path is outside umbrella root: $ROOT" >&2
    exit 1
    ;;
esac

# Walk ROOT → TARGET; collect directories that contain AGENTS.md.
# Print one absolute path per line, outer first.
rel="${TARGET#"$ROOT"}"
rel="${rel#/}"

chain=("$ROOT")
if [[ -n "$rel" ]]; then
  IFS='/' read -r -a parts <<<"$rel"
  acc="$ROOT"
  for p in "${parts[@]}"; do
    [[ -z "$p" ]] && continue
    acc="$acc/$p"
    chain+=("$acc")
  done
fi

found=0
for dir in "${chain[@]}"; do
  if [[ -f "$dir/AGENTS.md" ]]; then
    echo "$dir/AGENTS.md"
    found=$((found + 1))
  fi
done

if [[ "$found" -eq 0 ]]; then
  echo "ERR: no AGENTS.md on chain from $ROOT to $TARGET" >&2
  exit 1
fi
