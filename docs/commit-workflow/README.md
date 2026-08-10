# Commit workflow (rule 26) — SSoT

Canon: umbrella **AGENTS.md sacred rule 26**.

## Purpose

Agents finish durable work with a **strict commit path**. Humans should **not** need to say “commit the changes.”

## Portable entry

From **any directory**:

```bash
# Prefer path to umbrella scripts when known:
path/to/tyler-jewell/scripts/commit-workflow.sh --message "…"

# Or if PATH includes the scripts dir / you are inside a clone:
./scripts/commit-workflow.sh --message "…"
```

The script finds the **git root** of the work (or `--repo <path>`), classifies **context** from the diff, runs **risk-appropriate checks**, stages, and commits.

## Agent-driven, contextual checks

| Signal in changes | Checks (examples) |
|-------------------|-------------------|
| Docs / AGENTS / scorecard only | Umbrella `evals/` if under tyler-jewell; skip heavy tests |
| `herdr-kit/` | herdr-kit evals (+ umbrella if AGENTS/sacred touched) |
| `agent-kit/` | agent-kit evals; optional `test/run-tests.sh` if scripts/lib/tests change |
| `$HOME/system` / flake / modules | Prefer `validate-stack` / status when available; never `git add -A` on home |
| Mixed / high risk / unclear | Expand checks; if still unclear → **ask-user-question capability** |

**Rule:** run **only** what the change + risk justify. Do not punish a one-line README with the entire monorepo matrix. Do not skip required checks for the areas you actually touched.

## Flags (workflow)

| Flag | Meaning |
|------|---------|
| `--dry-run` | Print classification, checks that would run, status; no commit |
| `--message "…"` | Commit message (required to commit unless `--dry-run`) |
| `--repo <path>` | Explicit git work tree |
| `--push` | After successful commit, `git push` (only if remote tracking exists; never force) |
| `--yes` | Non-interactive (needed for push when policy requires) |

## Safety

- No secrets (rule 2)
- No force-push (rule 3)
- Sparse home git: stage allowlisted paths only — never `git add -A` from `$HOME`
- If checks fail: **do not commit**; fix or use ask-user-question capability

## Relation

| Rule | Link |
|------|------|
| 4 Truth | Checks must actually run |
| 5 Reversible | Commits reviewable; push is shared |
| 18 Scorecard | Include scorecard in same change set when requirements move |
| 24 Intent→implement | Commit is part of finishing the goal |
| 25 Agnostic | Invoke via plain language: “run the commit workflow” |
