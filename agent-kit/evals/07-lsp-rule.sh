#!/usr/bin/env bash
# DO: agent-kit AGENTS points at LSP rule 13 and declares Bash + public LSP.
set -euo pipefail
K="$(cd "$(dirname "$0")/.." && pwd)"
grep -q 'LSP rule 13\|rule 13' "$K/AGENTS.md"
grep -qi 'bash-language-server\|Bash' "$K/AGENTS.md"
echo "PASS agent-kit LSP declaration"
