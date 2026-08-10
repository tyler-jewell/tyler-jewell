#!/usr/bin/env bash
# Contextual commit workflow (tyler-jewell sacred rule 26).
# Runnable from any directory: resolves git root, classifies risk, runs needed checks, commits.
# Exit: 0 ok, 1 error, 2 usage.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UMBRELLA_HINT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DRY_RUN=0
PUSH=0
YES=0
MSG=""
REPO=""

usage() {
  cat <<EOF
commit-workflow — contextual checks + commit (rule 26)

USAGE
  commit-workflow.sh [--dry-run] [--repo PATH] --message "…" [--push] [--yes]
  commit-workflow.sh -h|--help

NO-ARGS
  Error (need --message or --dry-run). Not interactive.

BEHAVIOR
  Finds git root (from --repo or CWD). Classifies changed paths.
  Runs only relevant checks, then stages and commits.
  Never force-pushes. Never git add -A on sparse home git.

OPTIONS
  --dry-run     Show plan + checks; do not commit
  --repo PATH   Git work tree (default: discover from CWD)
  --message M   Commit message (required to commit)
  --push        git push after commit (needs tracking remote)
  --yes         Confirm push / non-interactive gates
  -h, --help    This help
EOF
}

die() {
  local code="$1"
  shift
  echo "error:"
  echo "  code: $code"
  echo "  message: $*"
  exit "$code"
}

help_line() {
  echo "help[1]:"
  echo "  $*"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help) usage; exit 0 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --push) PUSH=1; shift ;;
    --yes) YES=1; shift ;;
    --repo)
      REPO="${2:-}"
      [[ -n "$REPO" ]] || die 2 "--repo needs a path"
      shift 2
      ;;
    --message)
      MSG="${2:-}"
      [[ -n "$MSG" ]] || die 2 "--message needs text"
      shift 2
      ;;
    *)
      die 2 "unknown flag: $1"
      ;;
  esac
done

if [[ "$DRY_RUN" -eq 0 && -z "$MSG" ]]; then
  die 2 "need --message for commit (or --dry-run)"
  help_line "Run: commit-workflow.sh --message \"…\""
fi

# Resolve git root
if [[ -n "$REPO" ]]; then
  cd "$REPO" || die 1 "cannot cd to --repo $REPO"
else
  cd "$(pwd)" || true
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  die 1 "not inside a git work tree (pass --repo)"
fi
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "bin: ${SCRIPT_DIR}/commit-workflow.sh"
echo "git_root: $ROOT"
echo "mode: $([[ "$DRY_RUN" -eq 1 ]] && echo dry-run || echo commit)"

# Detect tree flavor
FLAVOR="generic"
if [[ -f "$ROOT/AGENTS.md" ]] && grep -q 'Tyler Jewell — umbrella charter' "$ROOT/AGENTS.md" 2>/dev/null; then
  FLAVOR="umbrella"
elif [[ -f "$ROOT/herdr-plugin.toml" ]] && grep -q 'tyler-jewell.herdr-kit' "$ROOT/herdr-plugin.toml" 2>/dev/null; then
  FLAVOR="herdr-kit"
elif [[ -f "$ROOT/flake.nix" ]] && [[ -d "$ROOT/modules/home" ]]; then
  FLAVOR="system"
elif [[ "$(basename "$ROOT")" == "agent-kit" ]] || [[ -d "$ROOT/scripts/lib" && -f "$ROOT/scripts/agent-status.sh" ]]; then
  FLAVOR="agent-kit"
elif [[ "$ROOT" == "$HOME" ]] || [[ -f "$ROOT/.gitignore" && -d "$ROOT/system" ]]; then
  # sparse home
  if [[ -d "$ROOT/system" && -f "$ROOT/AGENTS.md" ]]; then
    FLAVOR="home"
  fi
fi
echo "flavor: $FLAVOR"

# Collect change paths (bash 3.2 portable — no mapfile)
CHANGED_FILE="$(mktemp)"
trap 'rm -f "$CHANGED_FILE"' EXIT
git status --porcelain 2>/dev/null | awk '{print $NF}' | sed '/^$/d' >"$CHANGED_FILE" || true
if [[ ! -s "$CHANGED_FILE" ]]; then
  git ls-files --others --exclude-standard 2>/dev/null | head -200 >"$CHANGED_FILE" || true
fi
CHANGED_COUNT="$(wc -l <"$CHANGED_FILE" | tr -d ' ')"
echo "changed_count: ${CHANGED_COUNT:-0}"

# Risk / context flags
NEED_UMBRELLA_EVALS=0
NEED_HERDR_KIT_EVALS=0
NEED_AGENT_KIT_EVALS=0
NEED_AGENT_KIT_TESTS=0
NEED_SYSTEM_VALIDATE=0
NEED_HIERARCHY=0
RISK="low"

while IFS= read -r p || [[ -n "${p:-}" ]]; do
  [[ -z "$p" ]] && continue
  case "$p" in
    AGENTS.md | docs/* | README.md | docs/requirements/*)
      NEED_UMBRELLA_EVALS=1
      ;;
    evals/* | scripts/pipe-agents.sh | scripts/hierarchy-order.sh | scripts/commit-workflow.sh)
      NEED_UMBRELLA_EVALS=1
      NEED_HIERARCHY=1
      RISK="medium"
      ;;
    herdr-kit/*)
      NEED_HERDR_KIT_EVALS=1
      RISK="medium"
      ;;
    agent-kit/scripts/* | agent-kit/test/* | agent-kit/evals/*)
      NEED_AGENT_KIT_EVALS=1
      NEED_AGENT_KIT_TESTS=1
      RISK="medium"
      ;;
    agent-kit/*)
      NEED_AGENT_KIT_EVALS=1
      ;;
    system/* | modules/* | flake.nix | flake.lock | host-runtime.toml)
      NEED_SYSTEM_VALIDATE=1
      RISK="high"
      ;;
    *.go | go.mod | package.json | flake.nix)
      RISK="high"
      ;;
  esac
done <"$CHANGED_FILE"

# Flavor forces baseline checks
case "$FLAVOR" in
  umbrella)
    NEED_UMBRELLA_EVALS=1
    ;;
  herdr-kit)
    NEED_HERDR_KIT_EVALS=1
    ;;
  agent-kit)
    NEED_AGENT_KIT_EVALS=1
    ;;
  system | home)
    NEED_SYSTEM_VALIDATE=1
    ;;
esac

echo "risk: $RISK"
echo "checks_planned:"
[[ "$NEED_UMBRELLA_EVALS" -eq 1 ]] && echo "  - umbrella evals"
[[ "$NEED_HIERARCHY" -eq 1 ]] && echo "  - hierarchy fixture"
[[ "$NEED_HERDR_KIT_EVALS" -eq 1 ]] && echo "  - herdr-kit evals"
[[ "$NEED_AGENT_KIT_EVALS" -eq 1 ]] && echo "  - agent-kit evals"
[[ "$NEED_AGENT_KIT_TESTS" -eq 1 ]] && echo "  - agent-kit tests"
[[ "$NEED_SYSTEM_VALIDATE" -eq 1 ]] && echo "  - system validate/status (if present)"
if [[ "${CHANGED_COUNT:-0}" -eq 0 ]]; then
  echo "  - (no changes detected — status only)"
fi

run_check() {
  local name="$1"
  shift
  echo "check: $name"
  if ! "$@"; then
    die 1 "check failed: $name"
  fi
  echo "check_ok: $name"
}

# Locate umbrella for nested kits
UMBRELLA=""
if [[ "$FLAVOR" == "umbrella" ]]; then
  UMBRELLA="$ROOT"
elif [[ -f "${ROOT}/../AGENTS.md" ]] && grep -q 'umbrella charter' "${ROOT}/../AGENTS.md" 2>/dev/null; then
  UMBRELLA="$(cd "${ROOT}/.." && pwd)"
elif [[ -d "${UMBRELLA_HINT}" && -f "${UMBRELLA_HINT}/AGENTS.md" ]]; then
  UMBRELLA="$UMBRELLA_HINT"
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "result: dry-run (no commit)"
  git status -sb | head -40
  help_line "Commit: commit-workflow.sh --message \"…\" from any CWD"
  exit 0
fi

# Execute checks
if [[ "$NEED_UMBRELLA_EVALS" -eq 1 && -n "$UMBRELLA" && -x "${UMBRELLA}/evals/run.sh" ]]; then
  run_check "umbrella-evals" bash "${UMBRELLA}/evals/run.sh" run
fi
if [[ "$NEED_HIERARCHY" -eq 1 && -n "$UMBRELLA" && -x "${UMBRELLA}/test/run-hierarchy-check.sh" ]]; then
  run_check "hierarchy" bash "${UMBRELLA}/test/run-hierarchy-check.sh"
fi
if [[ "$NEED_HERDR_KIT_EVALS" -eq 1 ]]; then
  HK="$ROOT"
  [[ "$FLAVOR" == "umbrella" ]] && HK="${ROOT}/herdr-kit"
  if [[ -x "${HK}/scripts/evals.sh" ]]; then
    run_check "herdr-kit-evals" bash "${HK}/scripts/evals.sh" run
  fi
fi
if [[ "$NEED_AGENT_KIT_EVALS" -eq 1 ]]; then
  AK="$ROOT"
  [[ "$FLAVOR" == "umbrella" ]] && AK="${ROOT}/agent-kit"
  if [[ -x "${AK}/evals/run.sh" ]]; then
    run_check "agent-kit-evals" bash "${AK}/evals/run.sh" run
  fi
fi
if [[ "$NEED_AGENT_KIT_TESTS" -eq 1 ]]; then
  AK="$ROOT"
  [[ "$FLAVOR" == "umbrella" ]] && AK="${ROOT}/agent-kit"
  if [[ -x "${AK}/test/run-tests.sh" ]]; then
    run_check "agent-kit-tests" bash "${AK}/test/run-tests.sh"
  fi
fi
if [[ "$NEED_SYSTEM_VALIDATE" -eq 1 ]]; then
  if [[ -x "${HOME}/system/scripts/validate-stack.sh" ]]; then
    run_check "system-validate" bash "${HOME}/system/scripts/validate-stack.sh"
  elif [[ -x "${HOME}/system/scripts/system-status.sh" ]]; then
    run_check "system-status" bash "${HOME}/system/scripts/system-status.sh"
  else
    echo "check_skip: system validate not found"
  fi
fi

# Stage
if [[ "$FLAVOR" == "home" ]]; then
  if [[ -x "${HOME}/system/scripts/lib/sync_repo.sh" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/system/scripts/lib/sync_repo.sh"
    if type stage_allowlist >/dev/null 2>&1; then
      stage_allowlist
    else
      die 1 "home git: stage_allowlist unavailable — stage explicit paths only"
    fi
  else
    die 1 "home git: refuse git add -A; provide allowlist helper or stage manually"
  fi
else
  git add -A
fi

if git diff --cached --quiet; then
  die 1 "nothing staged to commit"
fi

git commit -m "$MSG"
echo "commit: $(git rev-parse --short HEAD)"
echo "result: committed"

if [[ "$PUSH" -eq 1 ]]; then
  if [[ "$YES" -ne 1 ]]; then
    die 1 "refusing --push without --yes"
  fi
  if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    git push
    echo "result: pushed"
  else
    die 1 "no upstream tracking branch"
  fi
fi

exit 0
