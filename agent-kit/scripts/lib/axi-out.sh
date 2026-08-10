#!/usr/bin/env bash
# Pure AXI-aligned output helpers (https://axi.md).
# Compact TOON-like text — no TOON runtime dependency.
# shellcheck shell=bash

# Render path with $HOME → ~
axi_home_path() {
  local p="${1:-}"
  local h="${HOME:-}"
  if [[ -n "$h" && "$p" == "$h"* ]]; then
    echo "~${p#"$h"}"
  else
    echo "$p"
  fi
}

# Header block: bin + description (principle 8 content-first framing)
axi_header() {
  local bin_path="${1:-}"
  local desc="${2:-}"
  printf 'bin: %s\n' "$(axi_home_path "$bin_path")"
  printf 'description: %s\n' "$desc"
}

# count: N  or  count: N of TOTAL (principle 4, 5)
axi_count() {
  local n="${1:-0}"
  local total="${2:-}"
  if [[ -n "$total" ]]; then
    printf 'count: %s of %s total\n' "$n" "$total"
  else
    printf 'count: %s\n' "$n"
  fi
}

# Definitive empty (principle 5)
axi_empty() {
  local name="${1:-results}"
  printf 'empty: 0 %s\n' "$name"
  axi_count 0
}

# TOON-like table:
# name[N]{f1,f2,f3}:
#   v1,v2,v3
# Args: name, fields_csv, then rows as "a,b,c" lines on stdin or remaining args
axi_table() {
  local name="${1:-items}"
  local fields="${2:-}"
  shift 2 || true
  local -a rows=()
  if [[ $# -gt 0 ]]; then
    rows=("$@")
  else
    while IFS= read -r line; do
      [[ -n "$line" ]] && rows+=("$line")
    done
  fi
  local n="${#rows[@]}"
  printf '%s[%s]{%s}:\n' "$name" "$n" "$fields"
  if [[ "$n" -eq 0 ]]; then
    printf '  (none)\n'
  else
    local r
    for r in "${rows[@]}"; do
      printf '  %s\n' "$r"
    done
  fi
}

# help[] next steps (principle 9) — one suggestion per arg
axi_help() {
  local n=$#
  printf 'help[%s]:\n' "$n"
  local s
  for s in "$@"; do
    printf '  %s\n' "$s"
  done
}

# Structured error on stdout (principle 6); caller sets exit code
axi_error() {
  local code="${1:-1}"
  local msg="${2:-error}"
  printf 'error:\n'
  printf '  code: %s\n' "$code"
  printf '  message: %s\n' "$msg"
}

# Truncate string with hint (principle 3). Args: text, max_chars (default 200)
axi_truncate() {
  local text="${1:-}"
  local max="${2:-200}"
  local len=${#text}
  if [[ "$len" -le "$max" ]]; then
    printf '%s' "$text"
    return 0
  fi
  printf '%s… (truncated, %s chars total — use --full for complete body)' "${text:0:max}" "$len"
}

# Score one principle met|na|fail → used by scorecard tooling (pure)
# Args: principle_id, status (met|na|fail), note
axi_score_line() {
  printf 'p%s: %s' "${1:-0}" "${2:-fail}"
  if [[ -n "${3:-}" ]]; then
    printf '  # %s' "$3"
  fi
  printf '\n'
}

# Aggregate score: count met among applicable (not na). Prints met/applicable and ok=yes|no
axi_score_summary() {
  local met="${1:-0}"
  local applicable="${2:-0}"
  printf 'axi_score: %s/%s\n' "$met" "$applicable"
  if [[ "$applicable" -gt 0 && "$met" -eq "$applicable" ]]; then
    printf 'axi_ok: yes\n'
  else
    printf 'axi_ok: no\n'
  fi
}
