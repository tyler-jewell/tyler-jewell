# Requirements maturity — score, commit, re-score

**Single source of truth for scores:** [scorecard.md](scorecard.md)

Sacred rules live in umbrella **AGENTS.md** in two sections (rule numbers stay global **1–26**):

| Section | When |
|---------|------|
| **Core requirements** | Every agent session, always |
| **Contributing requirements** | When updating code or the stack |

Today both ship in session context; **Contributing** may later move to **hooks on update**.

This scorecard tracks every sacred requirement with:

| Field | Meaning |
|-------|---------|
| **Score %** | 0–100, integer. Objective evidence only — no theater. |
| **Mode** | `mature` **only** at **100%**. Anything else is **`development`**. |
| **Logged at** | Git commit hash(es) of the tree(s) that evidence the score. |
| **Evidence** | What is actually version-controlled and replicable on a fresh machine. |
| **Gaps** | Concrete work remaining to reach 100%. |

## Public gate (non-negotiable)

> **We do not treat this overall setup as finished / “go public ready” until every requirement scores 100% (`mature`).**

While any row is `development`, agents and humans must treat the stack as **in development**: improve, fix bugs, refine, and **re-score** — do not claim full maturity or ship “we’re done” narratives.

“Go public” here means: declaring the **core methodology + host flake + product stack bar** complete for others to clone and run without heroics. Individual open-source repos (e.g. herdr-kit) may already be public as **in-progress** products; they still inherit `development` requirements until scores hit 100%.

## What 100% means (objective)

A requirement is **100%** only when **all** of the following are true:

1. **Policy** is written in sacred / project AGENTS (or linked SSoT).
2. **Implementation** lives in **version-controlled** core setup (public tyler-jewell / tyler-jewell and/or the host `system` flake that machines apply).
3. **Replicable** on a clean machine following docs only (no uncommitted local magic, no “works on my laptop” secrets).
4. **Automated or scripted proof** exists where applicable (`evals/`, tests, documented score procedure).
5. **No known gaps** remain in the Gaps column (must be empty or “none”).

If any of 1–5 fails, score **&lt; 100** and mode **`development`**. Prefer under-scoring over greenwashing.

## Scoring honesty rules

- Prefer **fail-open honesty**: if evidence is missing or only local, score lower.
- **Do not** score 100% for “docs only” when the requirement demands runtime/product behavior (passkeys, PWA, deploys).
- **Do not** count uncommitted host changes as replicable until they are in git on the machine’s system/home allowlist (and pushed if that repo is the recovery source).
- Upstream vendor limits (e.g. Herdr hook uses Python) may cap a score until we wrap/replace **or** explicitly document an allowed exception with residual risk — still not 100% if our bar says “never Python in our surfaces” and we still ship exceptions without a closed story.
- When uncertain between two scores, pick the **lower** one and list the doubt under Gaps.

## Agent protocol — mandatory re-score

**Any** agent session that produces learnings, updates, bugs fixed, issues found, or refinements that **affect** a scored requirement **must**:

1. Update [scorecard.md](scorecard.md) for every affected row (score, mode, evidence, gaps).
2. Set **Logged at** to the **new** commit hash(es) after the change lands (or the hash about to be committed; amend scorecard in the same commit when possible).
3. Set **Last rescore** date (UTC) and a one-line **Rescore reason**.
4. If overall gate is still not all-mature, leave **PUBLIC GATE: BLOCKED** at the top of the scorecard.
5. Dual-write if layout/commands change (`AGENTS.md` + `README.md` here).

Do **not** skip re-score because “it was only a small fix.” Small fixes change maturity.

### When re-score is required (triggers)

- Edit sacred `AGENTS.md` rules or requirement docs
- Change host flake packages that back a rule (go, gopls, vercel, LSP servers, …)
- Migrate languages / backends / auth / hosting / frontend stack
- Add or fail compliance evals related to a rule
- Discover a bug or gap that means a prior 100% was wrong → **immediately** lower score
- Close a gap listed in the scorecard

### When re-score is not required

- Pure typo in unrelated prose
- Work outside these requirements with no effect on scores

## How to re-score (procedure)

```bash
# 1. Read current scorecard + sacred rules
cat docs/requirements/scorecard.md
# 2. Gather evidence (evals, paths, commits)
./evals/run.sh run
git -C . rev-parse HEAD
git -C . rev-parse HEAD
# 3. Edit scorecard.md honestly
# 4. Commit scorecard with the code/docs change that triggered the rescore
```

## Related

| Doc | Role |
|-----|------|
| [../../AGENTS.md](../../AGENTS.md) | Sacred rules 1–17 + rule on maturity scoring |
| [scorecard.md](scorecard.md) | Live scores |
| [../web/README.md](../web/README.md) | Web/PWA/passkey/Vercel bar detail |
| [../lsp/README.md](../lsp/README.md) | LSP inventory |
| [../axi/axi-scorecard.md](../axi/axi-scorecard.md) | AXI surface scores (feeds rule 11) |
