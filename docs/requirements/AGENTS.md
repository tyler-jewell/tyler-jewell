# docs/requirements — agent notes

## Authority

Umbrella **AGENTS.md** sacred rules 1–21 plus **maturity / re-score** obligations documented in [README.md](README.md). Include DRY (19), simplicity (20), and **instruction authority / herdr-kit (21)**.

## Rules for agents

1. **Scorecard is SSoT for maturity** — [scorecard.md](scorecard.md). Do not invent a second scoring system.
2. **Honesty** — Prefer lower scores when evidence is weak. Never mark `mature` (100%) without VC + clean-machine replicability + proof.
3. **Development mode** — Any requirement &lt; 100% is `development`. Treat related work as unfinished infrastructure, not done product.
4. **Mandatory re-score** — If your session changes anything that affects a requirement (code, flake, evals, docs, bugs found), update the scorecard **in the same change set** when possible: score, mode, evidence, gaps, logged commit, rescore log, public gate.
5. **Public gate** — While any row is not 100%, keep **PUBLIC GATE: BLOCKED**. Do not tell humans the core setup is finished for public completion.
6. **Dual-write** — Keep README.md aligned when process changes.
7. **No secrets** in scorecard (no tokens, no private URLs with credentials).

## Quick commands

```bash
# Read gate + scores
sed -n '1,40p' docs/requirements/scorecard.md
# After code change: edit scorecard, then
git rev-parse HEAD
```
