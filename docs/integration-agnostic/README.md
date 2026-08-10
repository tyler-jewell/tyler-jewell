# Integration-agnostic methodology (rule 25)

Canon: umbrella **AGENTS.md sacred rule 25**. The stack is **~99% integration-agnostic**.

## Principle

Natural language drives the agent. Built-in plan / implement / compact / ask-human capabilities do the work. **Product slash commands and brand-named recipes are not our interface.**

## Prefer / avoid

| Prefer (natural language) | Avoid (product hacks) |
|---------------------------|------------------------|
| Implement this plan: … | `/implement this plan: …` |
| Plan the following change: … | `/plan …` as the only documented form |
| Compact context; promote learnings per our guidelines | Vendor-only compact slash as the methodology |
| Use your ask-user-question capability to … | “Call `ask_user_question` tool” as a magic token |
| Brand-neutral “agent runtime”, “coding agent” | Sacred docs that name one vendor as the only path |

## Credibility

If a coding agent **cannot** follow clear English plan/implement/compact/ask instructions that a capable agent **can**, that agent **loses credibility** for this methodology. Do **not** add permanent hacky adapters to paper over that failure. Improve wording, goals, and agent selection.

## Where brand/path names may appear

| Allowed | Not allowed in sacred/process docs |
|---------|-------------------------------------|
| Host filesystem paths that exist on a machine | “Always open with product X slash command” |
| Human-only day-0 notes for a binary already installed | Methodology that only works for one brand |
| Forbidden-example lists of **other products’** inventories (rule 9 anti-pattern) | Framing our stack as a single-vendor plugin |

## Related

- Rule 24 — intent → research → goal → **implement this plan** (plain language)
- Rule 23 — aggressive compact (threshold in host runtime config; process here stays agnostic)
- Rule 9 — live discovery, no frozen inventories
- Rule 20 — no complexity to paper over weak interfaces
