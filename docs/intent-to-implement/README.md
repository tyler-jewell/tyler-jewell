# Intent → research → goal → implement (rule 24)

Canon: umbrella **AGENTS.md sacred rule 24**. Wording stays **integration-agnostic** (rule 25).

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
3. If unsure / pushback needed → use your ask-user-question capability
4. Write a solid GOAL statement
5. Plan, then implement this plan (plain language — not product slash hacks)
6. Verify (tests, evals, scorecard if requirements touched)
```

## Goal statement (minimum)

| Field | Content |
|-------|---------|
| **Outcome** | What will be true when done |
| **Non-goals** | What we will not do |
| **Constraints** | Sacred rules, host/runtime, languages, ports, etc. |
| **Debt check** | Debt added / removed; simpler path? (rule 20) |
| **Success checks** | Commands/evals/proof that must pass |
| **Risk / rollback** | How to reverse if wrong |

## When to use your ask-user-question capability

Use it when:

- The ask is **ambiguous** (two reasonable designs)
- The ask seems **bad for the stack** (debt, hardcodes ports, wrong language, etc.)
- Tradeoffs need a **human choice**
- You would otherwise **guess**

Do **not** use it to offload basic research you can do yourself.

## Implement lane (natural language)

Once the goal is solid:

1. **Plan** the non-trivial work (written plan or design the human can accept)
2. **Implement this plan** (plain English brief — goal statement is the brief)
3. Keep implement turns **goal-scoped** — no drive-by refactors outside the goal

Tiny work (typo, one-line doc): state a one-line goal in chat, then do it.

**Do not** document product-only forms such as slash-prefixed implement/plan commands as our methodology (rule 25).

## Relation to other rules

| Rule | Interaction |
|------|-------------|
| 4 Truth | Research before claims of done |
| 5 Reversible | Prefer reversible implement steps |
| 18 Scorecard | Goal may require re-score |
| 19–20 DRY / simplicity | Research must surface multi-file copy and debt |
| 21 Human chat | Intent wins; still not raw-order execution |
| 23 Compaction | Compaction learnings may become the next goal/PR |
| 25 Agnostic | Natural language plan/implement only |

## Anti-patterns

| Bad | Good |
|-----|------|
| “Sure, implementing now” on a vague ask | Research → structured human questions → goal → implement this plan |
| Silent disagreement then half-implement | Ask-user-question capability with clear options |
| Plan that is just the user’s sentence | Goal with non-goals, debt, success checks |
| Slash-only product recipes in sacred docs | Plain English that any capable agent can follow |
