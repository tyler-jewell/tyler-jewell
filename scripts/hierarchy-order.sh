#!/usr/bin/env bash
# List AGENTS.md from umbrella root → path (outer → inner). AXI content-first.
# Exit: 0 success, 1 error, 2 usage/unknown flag.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
# shellcheck source=/dev/null
source "${ROOT}/agent-kit/scripts/lib/axi-out.sh" 2>/dev/null || true

usage() {
  cat <<EOF
hierarchy-order — AGENTS.md chain from umbrella root to a path (outer → inner)

USAGE
  hierarchy-order.sh [--raw] <path-under-umbrella>
  hierarchy-order.sh -h|--help

OPTIONS
  --raw   Print absolute AGENTS.md paths only (one per line)

NO-ARGS
  Error with structured message (path required). Not interactive.
EOF
}

if [[ $# -eq 0 ]]; then
  if type axi_error >/dev/null 2>&1; then
    axi_error 2 "path required"
    axi_help "Run \`hierarchy-order.sh <path>\`" "Run \`hierarchy-order.sh --help\`"
  else
    echo "error: path required" >&2
  fi
  exit 2
fi

TARGET=""
RAW=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --raw) RAW=1; shift ;;
    -h | --help) usage; exit 0 ;;
    -*)
      if type axi_error >/dev/null 2>&1; then
        axi_error 2 "unknown flag: $1"
        axi_help "Run \`hierarchy-order.sh --help\`"
      else
        echo "error: unknown flag: $1" >&2
      fi
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
  if type axi_error >/dev/null 2>&1; then
    axi_error 2 "path required"
  fi
  exit 2
fi

# Resolve target to absolute path.
ORIG="$TARGET"
if [[ "$TARGET" != /* ]]; then
  if [[ -d "$TARGET" ]]; then
    TARGET="$(cd "$TARGET" && pwd)"
  elif [[ -e "$TARGET" ]]; then
    TARGET="$(cd "$(dirname "$TARGET")" && pwd)/$(basename "$TARGET")"
  else
    # try from ROOT
    if [[ -d "${ROOT}/${ORIG}" ]]; then
      TARGET="$(cd "${ROOT}/${ORIG}" && pwd)"
    else
      if type axi_error >/dev/null 2>&1; then
        axi_error 1 "path not found: ${ORIG}"
      else
        echo "ERR: path not found: $ORIG" >&2
      fi
      exit 1
    fi
  fi
elif [[ -d "$TARGET" ]]; then
  TARGET="$(cd "$TARGET" && pwd)"
elif [[ -e "$TARGET" ]]; then
  TARGET="$(cd "$(dirname "$TARGET")" && pwd)"
else
  if type axi_error >/dev/null 2>&1; then
    axi_error 1 "path not found: ${ORIG}"
  fi
  exit 1
fi

case "$TARGET" in
  "$ROOT" | "$ROOT"/*) ;;
  *)
    if type axi_error >/dev/null 2>&1; then
      axi_error 1 "path outside umbrella root"
    else
      echo "ERR: path outside umbrella" >&2
    fi
    exit 1
    ;;
esac

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
paths=()
for dir in "${chain[@]}"; do
  if [[ -f "$dir/AGENTS.md" ]]; then
    paths+=("$dir/AGENTS.md")
    found=$((found + 1))
  fi
done

if [[ "$found" -eq 0 ]]; then
  if type axi_empty >/dev/null 2>&1; then
    axi_empty "agents_md"
    axi_error 1 "no AGENTS.md on chain"
  else
    echo "ERR: no AGENTS.md on chain" >&2
  fi
  exit 1
fi

# --raw: one absolute path per line (tests / piping)
if [[ "$RAW" -eq 1 ]]; then
  printf '%s\n' "${paths[@]}"
  exit 0
fi

if type axi_header >/dev/null 2>&1; then
  axi_header "$SELF" "AGENTS.md chain outer→inner under tyler-jewell umbrella"
  axi_count "$found"
fi

if type axi_table >/dev/null 2>&1; then
  rows=()
  i=0
  for p in "${paths[@]}"; do
    i=$((i + 1))
    rows+=("${i},$(axi_home_path "$p")")
  done
  axi_table chain "order,path" "${rows[@]}"
else
  printf '%s\n' "${paths[@]}"
fi

if type axi_help >/dev/null 2>&1; then
  axi_help \
    "Run \`hierarchy-order.sh --raw <path>\` for path-only list" \
    "Run \`pipe-agents.sh\` for sacred umbrella text" \
    "Run \`agent-kit/scripts/agent-status.sh\` for live host status" \
    "AXI: https://axi.md"
fi
exit 0
