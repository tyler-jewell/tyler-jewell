# Context compaction — SSoT guidelines (rule 23)

Canon: umbrella **AGENTS.md sacred rule 23**.

## Aggressive threshold

| Runtime | Setting | Our bar |
|---------|---------|--------|
| **Grok** | `~/.grok/config.toml` → `[session] auto_compact_threshold_percent` | **≤ 50** (default product is often 80–85 — too late for us) |
| Other agents | product equivalent (session compact %, context budget) | **≤ 50%** of context before auto-compact |

Agents configuring Grok under Tyler Jewell **must** keep:

```toml
[session]
auto_compact_threshold_percent = 50
```

Lower than 50 is allowed if the human prefers even more aggressive compacting. **Higher than 50 is not** for our standard setups without an explicit human override recorded in notes.

## Compaction is system improvement time

Every compaction (auto or `/compact`) is a **checkpoint** for the methodology stack:

1. **What did we learn?** bugs fixed, better defaults, missing sacred detail, host runtime, ports, evals, kit actions, flake packages, agent gotchas.
2. **Would future agents benefit?** If the knowledge dies with this transcript, that is a failure mode when the answer is yes.
3. **If yes → promote:**
   - Branch / **worktree** off `main` (or current integration branch).
   - Apply durable updates (AGENTS, docs, herdr-kit, system/host-runtime, evals, …).
   - Open a **PR into `main`** for **human approval**.
   - Do **not** force-push main; do **not** leave “session-only” truth when it belongs in VC.
4. **If no reusable learning:** compact and continue. No theater PR.

## Checklist (agents — at compact)

```text
[ ] Threshold still ≤ 50% for this runtime?
[ ] Session learnings listed (or explicit “none”)?
[ ] Reusable items → worktree + PR (or linked open PR)?
[ ] Scorecard re-score if a sacred requirement was affected (rule 18)?
[ ] No secrets in the PR body or tree?
```

## Related

| Rule | Link |
|------|------|
| Truth over theater | sacred 4 |
| Reversible / human on shared actions | sacred 3, 5 |
| DRY / SSoT | sacred 19 |
| Maturity re-score | sacred 18 |
| Instruction authority | sacred 21 |

## Anti-patterns

| Bad | Good |
|-----|------|
| Compact at 85% and lose half a session of methodology | Compact at ≤50%; promote learnings earlier |
| “I’ll remember for next time” only in chat | PR to `main` via worktree |
| Dump entire transcript into AGENTS | Small, reviewable diffs; dual-write only when layout changes |
| Force-push main after compact | Human-approved PR |
