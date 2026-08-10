# Sacred requirements scorecard

**PUBLIC GATE: BLOCKED** — not all requirements are `mature` (100%).  
Do **not** declare the core setup finished or “ready for public completion” until every row is **100% / mature**.

| Meta | Value |
|------|--------|
| **Last rescore (UTC)** | 2026-08-10 |
| **Rescore reason** | Rule 26 agent-driven contextual commit workflow |
| **tyler-jewell @ score** | d86b4c488e76301bcd8a4048157257143ae2a3a5 |
| **product UI** | removed from local stack |
| **host system flake** | floor only; methodology via herdr-kit |
| **Compact threshold** | host agent runtime ≤50% (this machine) |

**Overall maturity:** **development**  
**Rows mature (100%):** 0 / 26  
**Rows in development:** 26 / 26  
**Average (unweighted):** ~55%

---

## Legend

| Mode | Score | Meaning |
|------|------:|---------|
| `mature` | 100 | Policy + VC implementation + clean-machine replicable + proof; gaps empty |
| `development` | 0–99 | Work remains; agents must re-score on any related change |

**Score bands (guidance, not theater):**

| Band | Typical meaning |
|-----:|-----------------|
| 0–20 | Policy missing or only a one-line wish |
| 21–40 | Policy written; little or no implementation |
| 41–60 | Partial implementation; major gaps / not replicable |
| 61–80 | Solid progress; missing proof, edge cases, or full VC |
| 81–99 | Nearly done; residual gaps block 100% |
| 100 | Mature — public-gate eligible for this row |

---

## Scores (rules 1–26)

| ID | Requirement | Score | Mode | Logged at (primary) | Evidence (honest) | Gaps to 100% |
|----|-------------|------:|------|---------------------|-------------------|--------------|
| 1 | Dual-write law | **75** | development | tyler-jewell `4e96e63` | Policy in AGENTS; many dirs have both files; eval `05-dual-write` policy-level | Automated tree-wide proof that every ongoing work dir has both; zero known exceptions inventory |
| 2 | No secrets in git | **80** | development | tyler-jewell `4e96e63` | Policy + evals (no-secrets patterns); public trees clean of known dumps | Host/home git process fully documented; secret-scan in CI for all public repos |
| 3 | No destructive git without ask | **70** | development | tyler-jewell `4e96e63` | Sacred policy only; agents instructed | No mechanical guard (hooks/CI); cannot prove compliance historically |
| 4 | Truth over theater | **70** | development | tyler-jewell `4e96e63` | Cultural sacred rule; AXI + requirements scorecards; bridge.py stale ref fixed in this change set | Continuous audit culture; agents must re-score instead of claiming green; no automated “claimed vs proven” lint |
| 5 | Prefer reversible local work | **70** | development | tyler-jewell `4e96e63` | Policy; normal commits preferred | No checklist in agent kit for high-risk actions beyond prose |
| 6 | Identity of this umbrella | **90** | development | tyler-jewell `4e96e63` | Public repo + AGENTS + pipe script | 100% needs documented “session outside repo always injects charter” automation or always-on path |
| 7 | Hosts registry | **85** | development | tyler-jewell `4e96e63` | `hosts/` with macbook-pro + mac-studio templates | Live multi-host apply proven end-to-end on second machine from VC only |
| 8 | Pipeable charter | **95** | development | tyler-jewell `4e96e63` | Plain MD; `scripts/pipe-agents.sh`; no secrets in charter | Eval asserting pipe script output == AGENTS.md; raw GitHub URL always current |
| 9 | Live CLI/API discovery | **80** | development | tyler-jewell `4e96e63` | Sacred examples; herdr-kit bans frozen targets | Full inventory of all owned surfaces grepped/CI; mesh model discovery proven on GPU-less + GPU hosts |

| 10 | Mesh-LLM primary local/mesh | **45** | development | tyler-jewell `4e96e63` | Policy + agent-kit mesh helpers + docs | Mesh not guaranteed installed via flake; no VC “mesh up” for every host class; end-to-end OPENAI_BASE_URL proof on macbook-pro |
| 11 | AXI alignment | **78** | development | tyler-jewell `4e96e63` | Sacred rule + `docs/axi/axi-scorecard.md`; owned CLIs claimed 10/10 applicable; bridge row corrected to Go | Continuous re-audit; not all agent surfaces inventoried; skeptic re-score cadence not automated |
| 12 | herdr-kit isolatable surface | **70** | development | tyler-jewell herdr-kit | Plugin flash/status/pipe; dry-run default | Mac soak incomplete; multi-host unproven |
| 13 | LSP setup + agent use | **55** | development | tyler-jewell `4e96e63` | Declarations in AGENTS; gopls/go on **this** host via HM | **bash-language-server / html-css LSPs not in core flake packages**; agent “must use LSP” not session-guaranteed; nil/nixd not on PATH by default; system flake changes not fully committed at score time |

| 14 | Go only — never Python | **60** | development | system packages (local) | Go rule; herdr-kit shell+docs; sacred ban | Host still installs `python3` for upstream hook; scripting still mostly Bash not Go; no umbrella-wide “no py” CI; system package change not fully VC-published; axiom docs stale refs |
| 15 | Frontend vanilla + PWA + shadcn | **40** | development | tyler-jewell | Policy only; no product UI in tree | **No web app manifest / service worker / offline**; **no Lighthouse PWA score logged in VC**; shadcn not used (allowed if zero package) but PWA bar unmet; no release checklist automation |
| 16 | WebAuthn passkeys | **15** | development | tyler-jewell `4e96e63` | Policy only (rule 16 + docs/web) | **No passkey implementation** in any web app/backend; no shared Go WebAuthn module; no eval |
| 17 | Public hosting on Vercel | **40** | development | system `vercel-cli.nix` (local) · tyler-jewell `4e96e63` | Policy; Vercel CLI shim module; `vercel` on this host PATH after apply | **No public app/DB/MCP deployed on Vercel from this stack**; vercel login is human and not proven in VC; CLI install uses bun+XDG (replicable only after HM apply **and** network); module may be uncommitted; no product deploy yet |
| 18 | Requirements maturity scoring | **70** | development | tyler-jewell `328c5a7` | Scorecard + rule 18 + eval `09-requirements-scorecard`; public gate BLOCKED | All rows mature; automated rescore discipline proven across sessions; host flake commits included in logged hashes |
| 19 | DRY / SSoT (stop multi-file copy) | **35** | development | tyler-jewell `df6a366` | Sacred rule 19 + README pointer; related to rule 9 live discovery | No mechanical “second/third file same fact” lint; known doc/code duplications not inventoried; agent habit not proven; shared libs/generators for repeated config still ad hoc |
| 20 | Simplicity / tests must not drive debt | **35** | development | tyler-jewell `9db877c` | Sacred rule 20 + README; stop-and-fix paired with rule 19 | Cultural only so far; no review checklist automation; known over-complex tests/evals not inventoried; habit not proven across agents |
| 21 | Instruction authority + herdr-kit flash | **45** | development | tyler-jewell `79d730d` | Rule 21 + authority section; herdr-kit with flash/wipe/bootstrap dry-run; docs/herdr-native | Mac soak not run; GitHub install path unproven; multi-agent inject not automatic; wipe apply not soak-logged |
| 22 | No hardcoded local ports / ports.toml | **50** | development | tyler-jewell | Rule 22; docs/ports; ports.toml beside AGENTS trees; ports.toml on AGENTS trees | Cross-tree claim conflict checker not automated; Mesh-LLM 9337 still prose default; all machines not proven |
| 23 | Aggressive compact + promote on compact | **45** | development | tyler-jewell + host agent config | Rule 23; docs/compaction; ≤50% threshold on this host | Habit/PR-on-compact not proven; multi-host runtime config not uniform |
| 24 | Never raw-ask → code; goal then implement | **40** | development | tyler-jewell | Rule 24; docs/intent-to-implement; NL plan/implement + ask-user-question capability | Agent habit unproven; no mechanical gate before edits |
| 25 | 99% integration-agnostic NL | **50** | development | tyler-jewell `c2fd344` | Rule 25; docs/integration-agnostic; sacred rules scrubbed of product slash hacks | Host docs/scripts may still name install paths; historical scorecard logs may retain old brand notes |
| 26 | Agent-driven contextual commits | **45** | development | tyler-jewell `d86b4c4` | Rule 26 in AGENTS; docs/commit-workflow; scripts/commit-workflow.sh (from any CWD) | Habit unproven; home allowlist path edge cases; risk classifier still heuristic |

---

## Aggregate

| Metric | Value |
|--------|------:|
| Requirements | 26 |
| Mature (100%) | **0** |
| Development | **26** |
| Min score | **15** (rule 16 passkeys) |
| Max score | **95** (rule 8 pipeable) |
| Unweighted average | **~55%** |
| **Public gate** | **BLOCKED** |

---

## Re-score log (append-only summary)

| UTC date | Primary commit(s) | Reason | Gate |
|----------|-------------------|--------|------|
| 2026-08-10 | tyler-jewell `f1b13fe` (scorecard + rule 18) · pin `62e5be9` / `bed5218` | Baseline honest maturity scoring for all sacred requirements 1–17 | BLOCKED |
| 2026-08-10 | tyler-jewell `df6a366` (rule 19 DRY/SSoT + scorecard 1–19) · pin `cd6d2c6` | Add DRY core requirement; scorecard covers 1–19 | BLOCKED |
| 2026-08-10 | tyler-jewell `9db877c` (rule 20 simplicity / tests-not-debt) | Add stop-and-fix simplicity requirement; scorecard 1–20 | BLOCKED |
| 2026-08-10 | tyler-jewell `79d730d` (rule 21 + herdr-kit core) | Authority chain + flash/dry-run/wipe kit; web/browser out of core | BLOCKED |
| 2026-08-10 | tyler-jewell `0c4f6a6` (rule 22 ports.toml) | No hardcoded local app ports; ports.toml claims | BLOCKED |
| 2026-08-10 | tyler-jewell `e8fc660` (rule 23 compaction) | ≤50% auto-compact; compact → worktree/PR promotion guidelines | BLOCKED |
| 2026-08-10 | tyler-jewell `2e646fb` (rule 24 intent→implement) | Ban raw-ask execution; research, goal, deliberate implement + ask_user_question | BLOCKED |
| 2026-08-10 | tyler-jewell `c2fd344` (rule 25 integration-agnostic) | NL over product slash hacks; brand-neutral sacred process | BLOCKED |
| 2026-08-10 | tyler-jewell `d86b4c4` (rule 26 commit workflow) | Agent-driven contextual commits; portable commit-workflow.sh | BLOCKED |

*(Each rescore: append a row here and rewrite the table above — do not delete history rows.)*

---

## Agent checklist after work that touches requirements

- [ ] Updated scores/modes/gaps for every affected ID  
- [ ] Logged commit hashes match the trees you changed  
- [ ] Appended re-score log row  
- [ ] Left PUBLIC GATE **BLOCKED** unless all 17 are 100%  
- [ ] Did not claim “setup complete” or “ready for public finish” while gate blocked  
