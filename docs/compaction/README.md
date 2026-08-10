# Context compaction — SSoT guidelines (rule 23)

Canon: umbrella **AGENTS.md sacred rule 23**. Product-agnostic (rule 25).

## Aggressive threshold

Configure the **agent runtime** so auto-compaction fires at **≤ 50%** of the context window. Prefer **50 or lower**. Lax defaults (often 80–85%) are **not** our standard.

Host-local runtime config holds the actual key (varies by product). Methodology never requires a brand-specific slash command to compact.

## Compaction is system improvement time

Every compaction (auto or manual) is a **checkpoint**:

1. **What did we learn?**
2. **Would future agents benefit?**
3. **If yes →** worktree + **PR into `main`** for human approval
4. **If no** → compact and continue (no theater PR)

## Checklist (at compact)

```text
[ ] Threshold still ≤ 50% for this runtime?
[ ] Session learnings listed (or explicit “none”)?
[ ] Reusable items → worktree + PR (or linked open PR)?
[ ] Scorecard re-score if a sacred requirement was affected (rule 18)?
[ ] No secrets in the PR body or tree?
```

## Related

Rules 3–5, 18–21, 25. Prefer plain language: “compact context and promote learnings per our guidelines.”
