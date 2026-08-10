#!/usr/bin/env bash
# Collect local host facts via live OS commands (not frozen hostname lists).
# shellcheck shell=bash

KIT_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${KIT_LIB}/gpu-classify.sh"

collect_gpu_probe_text() {
  local out=""
  if command -v system_profiler >/dev/null 2>&1; then
    out+="$(system_profiler SPDisplaysDataType 2>/dev/null || true)"$'\n'
  fi
  if command -v nvidia-smi >/dev/null 2>&1; then
    out+="$(nvidia-smi 2>&1 || true)"$'\n'
  fi
  if [[ -z "$out" ]] && command -v lspci >/dev/null 2>&1; then
    out+="$(lspci 2>/dev/null | grep -iE 'vga|3d|display' || true)"$'\n'
  fi
  printf '%s' "$out"
}

# Print key=value facts for local machine.
collect_local_host_facts() {
  local hostname_s user_s os_s arch_s home_s gpu_text gpu_flag
  hostname_s="$(hostname -s 2>/dev/null || hostname 2>/dev/null || echo unknown)"
  user_s="$(id -un 2>/dev/null || echo unknown)"
  os_s="$(uname -s 2>/dev/null || echo unknown)"
  arch_s="$(uname -m 2>/dev/null || echo unknown)"
  home_s="${HOME:-unknown}"
  gpu_text="$(collect_gpu_probe_text)"
  if classify_llm_gpu_from_text "$gpu_text"; then
    gpu_flag="yes"
  else
    gpu_flag="no"
  fi

  local slug
  slug="$(echo "$hostname_s" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')"
  [[ -z "$slug" ]] && slug="unknown-host"

  cat <<EOF
slug=${slug}
hostname=${hostname_s}
username=${user_s}
os=${os_s}
arch=${arch_s}
home=${home_s}
llm_gpu=${gpu_flag}
full_setup_eligible=$(accept_full_setup_target "$gpu_flag" && echo yes || echo no)
EOF
}

# Parse Host entries from ssh config text (pure).
# Prints one host alias per line (skips *, HostName-only junk).
parse_ssh_config_hosts() {
  local text="${1:-}"
  # BSD awk-friendly (no character-class pitfalls)
  echo "$text" | awk '
    BEGIN { IGNORECASE = 1 }
    $1 == "Host" || $1 == "host" {
      for (i = 2; i <= NF; i++) {
        h = $i
        if (h == "*") continue
        if (index(h, "*") || index(h, "?")) continue
        print h
      }
    }
  '
}

# Read local ~/.ssh/config if present.
list_ssh_config_hosts() {
  local f="${HOME}/.ssh/config"
  if [[ -f "$f" ]]; then
    parse_ssh_config_hosts "$(cat "$f")"
  fi
}
