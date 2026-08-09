#!/usr/bin/env bash
# Emit umbrella AGENTS.md only (pipeable into any agent/tool).
# No secrets; plain stdout.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec cat "${ROOT}/AGENTS.md"
