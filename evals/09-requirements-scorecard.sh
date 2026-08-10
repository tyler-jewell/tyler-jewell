#!/usr/bin/env bash
# DO: sacred rule 18 — requirements scorecard exists, scores all 1–20, development/public gate honesty.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$ROOT/AGENTS.md"
SC="$ROOT/docs/requirements/scorecard.md"
RD="$ROOT/docs/requirements/README.md"

test -f "$SC"
test -f "$RD"
test -f "$ROOT/docs/requirements/AGENTS.md"

# Sacred rule 18 present
grep -E '^18\. \*\*Requirements maturity' "$A"
grep -qi 'scorecard' "$A"
grep -qi 'development' "$A"
grep -qi 're-score\|rescore' "$A"
grep -qi 'public gate\|PUBLIC GATE' "$A"

# Scorecard structure
grep -q 'PUBLIC GATE' "$SC"
grep -qi 'BLOCKED\|OPEN' "$SC"
grep -q 'Last rescore' "$SC"
grep -qi 'Logged at' "$SC"
grep -qi 'development' "$SC"
grep -qi 'mature' "$SC"

# Sacred rule 19 DRY present
grep -E '^19\. \*\*DRY' "$A"
grep -qi 'single source of truth\|SSoT' "$A"
grep -qiE 'second|third' "$A"

# Sacred rule 20 simplicity / tests-not-debt present
grep -E '^20\. \*\*Simplicity' "$A"
grep -qi 'Could this be simpler' "$A"
grep -qi 'tech debt' "$A"
grep -qi 'STOP and fix\|stop and fix' "$A"

# Sacred rule 21 instruction authority
grep -E '^21\. \*\*Instruction authority' "$A"
grep -qi 'outer→inner\|outer -> inner\|Load outer' "$A"
grep -qi 'herdr-kit' "$A"

# Sacred rule 22 ports.toml
grep -E '^22\. \*\*Never hardcode local app ports' "$A"
grep -qi 'ports\.toml' "$A"
test -f "$ROOT/docs/ports/README.md"
test -f "$ROOT/ports.toml"

# Sacred rule 23 compaction
grep -E '^23\. \*\*Aggressive context compaction' "$A"
grep -qi '50%' "$A"
grep -qi 'worktree' "$A"
grep -qi 'PR\|pull request' "$A"
test -f "$ROOT/docs/compaction/README.md"
grep -qi 'auto_compact_threshold_percent' "$ROOT/docs/compaction/README.md"

# Sacred rule 24 intent → implement
grep -E '^24\. \*\*Never treat a raw human ask' "$A"
grep -qi 'ask_user_question' "$A"
grep -qi 'goal statement\|solid goal' "$A"
grep -qi 'implement' "$A"
test -f "$ROOT/docs/intent-to-implement/README.md"

# Every requirement ID 1–24 appears as a scored row (markdown table)
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24; do
  grep -E "^\\| *${i} +\\|" "$SC" >/dev/null || {
    echo "FAIL: scorecard missing row for requirement $i"
    exit 1
  }
done

# Process docs: 100% definition + re-score triggers + public gate
grep -qi '100%' "$RD"
grep -qi 'replicable\|clean machine\|version-controlled' "$RD"
grep -qi 'Mandatory re-score\|mandatory re-score' "$RD"
grep -qi 'Public gate' "$RD"

# DON'T allow claiming all mature without scores being 100 — if gate says OPEN, every score must be 100
if grep -qi 'PUBLIC GATE: *OPEN' "$SC"; then
  if grep -E '^\| *[0-9]+ +\|' "$SC" | grep -vi '100' | grep -qi 'development'; then
    echo "FAIL: PUBLIC GATE OPEN but development rows remain"
    exit 1
  fi
fi

# Honesty: if any development mode present, gate must not claim finished
if grep -qi '| *development *|' "$SC"; then
  if grep -qiE 'PUBLIC GATE: *OPEN|all requirements are mature' "$SC"; then
    echo "FAIL: development rows but gate claims open/mature"
    exit 1
  fi
fi

echo "PASS requirements maturity scorecard (rule 18)"
