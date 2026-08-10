# Intent → research → goal → implement (rule 24)

Canon: umbrella **AGENTS.md sacred rule 24**.

## Forbidden default

```text
Human: "do X"
Agent: *immediately edits 12 files*
```

That path is **banned**.

## Required path

```text
1. Hear ask (intent only)
2. Slow down — research effect + debt + sacred rules
3. If unsure / pushback needed → ask_user_question
4. Write a solid GOAL statement
5. Kick deliberate IMPLEMENT lane (plan→implement / implement agent with goal brief)
6. Verify (tests, evals, scorecard if requirements touched)
```

## Goal statement (minimum)

A goal is “solid” when it includes:

| Field | Content |
|-------|---------|
| **Outcome** | What will be true when done |
| **Non-goals** | What we will not do |
| **Constraints** | Sacred rules, host/runtime, no-Python, ports, etc. |
| **Debt check** | Debt added / removed; simpler path? (rule 20) |
| **Success checks** | Commands/evals/proof that must pass |
| **Risk / rollback** | How to reverse if wrong |

Template:

```markdown
## Goal
- Outcome: …
- Non-goals: …
- Constraints: …
- Debt: …
- Success: …
- Rollback: …
```

## When to use `ask_user_question`

Use it when:

- The ask is **ambiguous** (two reasonable designs)
- The ask seems **bad for the stack** (debt, anti-Herdr, hardcodes ports, Python, etc.)
- Tradeoffs need a **human choice** (always-on, purge auth, destructive wipe, public gate claims)
- You would otherwise **guess**

Do **not** use it to offload basic research you can do yourself.

## Implement lane (Grok)

Prefer, once the goal is solid:

1. **`/plan`** (or design) for non-trivial work → human-aligned plan  
2. **Execute / implement** against that plan (execute-plan skill, implement agent, or focused implement turn with the goal as the only brief)  
3. Keep implement turns **goal-scoped** — no drive-by refactors outside the goal  

Tiny work (typo, one-line doc): state a one-line goal in chat, then do it. No full plan ceremony required.

## Relation to other rules

| Rule | Interaction |
|------|-------------|
| 4 Truth | Research before claims of done |
| 5 Reversible | Prefer reversible implement steps |
| 18 Scorecard | Goal may require re-score |
| 19–20 DRY / simplicity | Research must surface multi-file copy and debt |
| 21 Human chat | Intent wins; still not raw-order execution |
| 23 Compaction | Compaction learnings may become the next goal/PR |

## Anti-patterns

| Bad | Good |
|-----|------|
| “Sure, implementing now” on a vague ask | Research → questions → goal → implement |
| Silent disagreement then half-implement | `ask_user_question` with clear options |
| Plan that is just the user’s sentence | Goal with non-goals, debt, success checks |
| Implement agent without a brief | Goal statement pasted as implement prompt |
