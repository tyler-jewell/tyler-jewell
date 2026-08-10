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

# Assert shipped herdr-web has no hard-coded OFFICIAL_TARGETS.
herdr_web_root() {
  if [[ -n "${HERDR_WEB_ROOT:-}" && -d "${HERDR_WEB_ROOT}" ]]; then
    echo "${HERDR_WEB_ROOT}"
  elif [[ -d "${HOME}/github-repos/herdr-web" ]]; then
    echo "${HOME}/github-repos/herdr-web"
  elif [[ -d "${HOME}/herdr-web" ]]; then
    echo "${HOME}/herdr-web"
  else
    echo ""
  fi
}

herdr_web_no_frozen_targets() {
  local root
  root="$(herdr_web_root)"
  if [[ -z "$root" || ! -d "$root" ]]; then
    echo "WARN: herdr-web missing (set HERDR_WEB_ROOT or clone tyler-jewell/herdr-web)" >&2
    return 1
  fi
  if grep -R --include='*.js' --include='*.py' -nE 'OFFICIAL_TARGETS\s*=' "$root/js" "$root/scripts" 2>/dev/null \
    || grep -R --include='*.js' --include='*.py' -nE 'frozenset\(\s*\{' "$root/js" "$root/scripts" 2>/dev/null; then
    echo "ERR: frozen OFFICIAL_TARGETS assignment found under herdr-web" >&2
    return 1
  fi
  echo "OK herdr-web: no frozen OFFICIAL_TARGETS assignment"
  return 0
}

# Run herdr-web unit tests if present.
herdr_web_run_tests() {
  local root
  root="$(herdr_web_root)"
  if [[ -n "$root" && -x "$root/test/run.sh" ]]; then
    "$root/test/run.sh"
  else
    echo "WARN: herdr-web test/run.sh missing (set HERDR_WEB_ROOT)" >&2
    return 1
  fi
}
