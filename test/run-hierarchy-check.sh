#!/usr/bin/env bash
# Drive shipped hierarchy-order.sh on the in-repo multi-level fixture.
# Fails if chain missing, wrong order, or depth < 3 AGENTS files.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ORDER="$ROOT/scripts/hierarchy-order.sh"
PROBE="$ROOT/hosts/macbook-pro/projects/_hierarchy-probe"

die() { echo "FAIL: $*" >&2; exit 1; }

[[ -x "$ORDER" || -f "$ORDER" ]] || die "missing hierarchy-order.sh"
chmod +x "$ORDER" "$ROOT/scripts/pipe-agents.sh" 2>/dev/null || true

[[ -d "$PROBE" ]] || die "missing fixture $PROBE"
[[ -f "$ROOT/AGENTS.md" ]] || die "missing umbrella AGENTS.md"
[[ -f "$ROOT/hosts/macbook-pro/AGENTS.md" ]] || die "missing host AGENTS.md"
[[ -f "$PROBE/AGENTS.md" ]] || die "missing probe AGENTS.md"

# Bash 3.2-compatible (macOS /bin/bash): no mapfile
lines=()
while IFS= read -r line; do
  [[ -n "$line" ]] && lines+=("$line")
done < <("$ORDER" --raw "$PROBE")
n="${#lines[@]}"

echo "=== hierarchy-order ($n files) ==="
printf '%s\n' "${lines[@]}"

[[ "$n" -ge 3 ]] || die "expected depth>=3 AGENTS files, got $n"

# Outer → inner: umbrella first, probe last
first="${lines[0]}"
last="${lines[$((n - 1))]}"

[[ "$first" == "$ROOT/AGENTS.md" ]] || die "first must be umbrella AGENTS.md, got: $first"
[[ "$last" == "$PROBE/AGENTS.md" ]] || die "last must be probe AGENTS.md, got: $last"

# Host must appear between umbrella and probe
host_hit=0
i=0
while [[ $i -lt $n ]]; do
  p="${lines[$i]}"
  if [[ "$p" == "$ROOT/hosts/macbook-pro/AGENTS.md" ]]; then
    host_hit=1
  fi
  i=$((i + 1))
done
[[ "$host_hit" -eq 1 ]] || die "host AGENTS.md missing from chain"

# Order: each path is a prefix extension of previous parent dir
prev_dir=""
i=0
while [[ $i -lt $n ]]; do
  p="${lines[$i]}"
  d="$(dirname "$p")"
  if [[ -n "$prev_dir" ]]; then
    case "$d" in
      "$prev_dir"|"$prev_dir"/*) ;;
      *) die "order inverted or non-nested: $prev_dir then $d" ;;
    esac
  fi
  prev_dir="$d"
  i=$((i + 1))
done

# Sacred marker in umbrella
grep -q 'Sacred' "$ROOT/AGENTS.md" || die "umbrella missing Sacred language"
grep -qi 'overall\|primary' "$ROOT/AGENTS.md" || die "umbrella missing overall/primary language"

# Pipe script bytes match file
pipe_out="$("$ROOT/scripts/pipe-agents.sh")"
file_out="$(cat "$ROOT/AGENTS.md")"
[[ "$pipe_out" == "$file_out" ]] || die "pipe-agents.sh output != AGENTS.md"
[[ -n "$pipe_out" ]] || die "pipe output empty"

echo "PASS: hierarchy outer→inner ($n levels), umbrella first, probe last, pipe OK"
