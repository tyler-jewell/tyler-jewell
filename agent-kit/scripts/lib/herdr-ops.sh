#!/usr/bin/env bash
# Pure herdr CLI runners — no target inventories, no install reimplementation.
# shellcheck shell=bash

export PATH="${HOME}/.local/bin:${HOME}/.nix-profile/bin:${PATH}"

herdr_bin() {
  command -v herdr 2>/dev/null || true
}

# Run herdr with given args; print stdout; return exit code of herdr.
run_herdr() {
  local bin
  bin="$(herdr_bin)"
  if [[ -z "$bin" ]]; then
    echo "ERR: herdr not on PATH" >&2
    return 127
  fi
  "$bin" "$@"
}

herdr_config_check() {
  run_herdr config check
}

herdr_integration_status() {
  run_herdr integration status
}

herdr_integration_install_help() {
  run_herdr integration install --help 2>&1 || true
}

# Assert kit scripts have no hard-coded OFFICIAL_TARGETS.
herdr_kit_no_frozen_targets() {
  local root="${HERDR_KIT_ROOT:-}"
  if [[ -z "$root" ]]; then
    if [[ -d "${HOME}/github-repos/tyler-jewell/herdr-kit" ]]; then
      root="${HOME}/github-repos/tyler-jewell/herdr-kit"
    elif [[ -d "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" ]]; then
      root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/herdr-kit"
      # agent-kit/scripts/lib → umbrella is ../../..
      root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)/herdr-kit"
    fi
  fi
  if [[ -z "$root" || ! -d "$root" ]]; then
    echo "WARN: herdr-kit missing" >&2
    return 1
  fi
  if grep -R --include='*.sh' --include='*.go' --include='*.js' -nE 'OFFICIAL_TARGETS\s*=' "$root" 2>/dev/null; then
    echo "ERR: frozen OFFICIAL_TARGETS under herdr-kit" >&2
    return 1
  fi
  echo "OK herdr-kit: no frozen OFFICIAL_TARGETS"
  return 0
}
