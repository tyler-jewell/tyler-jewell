#!/usr/bin/env bash
# Emit umbrella AGENTS.md (pipeable). AXI content-first: no-args = charter body.
# Exit: 0 success, 1 missing file, 2 usage.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
# shellcheck source=/dev/null
source "${ROOT}/agent-kit/scripts/lib/axi-out.sh" 2>/dev/null || true

usage() {
  cat <<EOF
pipe-agents — print sacred tyler-jewell AGENTS.md to stdout

USAGE
  pipe-agents.sh [-h|--help]

NO-ARGS
  Emits AGENTS.md (content first). No interactive prompts.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    *)
      if type axi_error >/dev/null 2>&1; then
        axi_error 2 "unknown flag: $1"
        axi_help "Run \`pipe-agents.sh --help\`"
      else
        echo "error: unknown flag: $1" >&2
      fi
      exit 2
      ;;
  esac
done

if [[ ! -f "${ROOT}/AGENTS.md" ]]; then
  if type axi_error >/dev/null 2>&1; then
    axi_error 1 "AGENTS.md missing at $(axi_home_path "$ROOT")"
  else
    echo "error: AGENTS.md missing" >&2
  fi
  exit 1
fi

# Content first: body is the charter (agents pipe this into context)
cat "${ROOT}/AGENTS.md"

# Trailing AXI disclosure (compact; does not pollute charter semantics when piped —
# agents that want pure charter can head -n -N; still provide help for interactive runs)
if [[ -t 1 ]]; then
  echo
  if type axi_help >/dev/null 2>&1; then
    axi_help \
      "Pipe: \`pipe-agents.sh | your-agent-loader\`" \
      "Hierarchy: \`hierarchy-order.sh <path>\`" \
      "Status: \`agent-kit/scripts/agent-status.sh\`" \
      "AXI: https://axi.md"
  fi
fi
exit 0
