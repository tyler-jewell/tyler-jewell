# Umbrella methodology evals

Compliance checks for sacred tyler-jewell policy (≤10). Not challenge tasks.
Run: `bash evals/run.sh list|run` or via herdr-kit evals action.

**LSP (rule 13):** this tree is shell evals only — Bash + public `bash-language-server`; agents must use LSP when editing scripts; no suppressions-as-fix.

**Maturity (rule 18):** `09-requirements-scorecard.sh` asserts scorecard + public gate process. Scores themselves live in `docs/requirements/scorecard.md` — update them when requirements change; do not fake 100%.
