#!/usr/bin/env bash
# Content-first kit/herdr status. Always safe (no writes).
set -euo pipefail
KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/common.sh
source "${KIT_ROOT}/scripts/lib/common.sh"

usage() {
  cat <<EOF
status — herdr-kit + herdr live summary

USAGE
  status.sh [-h|--help]

NO-ARGS
  Prints status (content first). Never writes.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    *)
      kit_error 2 "unknown flag: $1"
      kit_help "Run \`status.sh --help\`"
      exit 2
      ;;
  esac
done

echo "bin: ${KIT_ROOT}/scripts/status.sh"
echo "kit_root: $KIT_ROOT"
echo "umbrella: $UMBRELLA_ROOT"
echo "herdr_config_dir: $HERDR_CONFIG_DIR"
if command -v herdr >/dev/null 2>&1; then
  echo "herdr: $(command -v herdr) ($(herdr --version 2>/dev/null | head -1))"
  herdr config check 2>&1 | sed 's/^/herdr_config: /' || echo "herdr_config: check failed"
  herdr plugin list 2>&1 | sed 's/^/plugin: /' || true
else
  echo "herdr: missing on PATH"
fi
if command -v grok >/dev/null 2>&1; then
  echo "grok: $(command -v grok)"
else
  echo "grok: not on PATH"
fi
echo "desired_config: $DESIRED_CONFIG ($(test -f "$DESIRED_CONFIG" && echo present || echo missing))"
echo "desired_plugins: $DESIRED_PLUGINS ($(test -f "$DESIRED_PLUGINS" && echo present || echo missing))"
echo "scope: core only (no product web UI / browser)"
kit_help \
  "Run flash dry-run: \`scripts/flash.sh\`" \
  "Pipe AGENTS: \`scripts/pipe-agents.sh\`" \
  "AXI: https://axi.md"
exit 0
