# Tyler Jewell — umbrella charter (sacred)

You are operating under the **Tyler Jewell** umbrella. This file is the **overall / primary** agent charter for all machines, hosts, and projects under this identity.

**Sacred:** do not add, edit, or weaken these rules lightly. Change only when certain that (1) the rule will remain true for years, (2) every agent under Tyler Jewell must follow it, and (3) tool defaults do not already enforce it.

---

## Authority order (overall → specialization)

**Sacred rule 21** is binding. Summary:

**Conflict priority (highest → lowest):**

0. Explicit **human chat** for this turn  
1. **Sacred rules in this file** (umbrella)  
2. **Deepest** `AGENTS.md` on the work path (specialization)  
3. Parent `AGENTS.md` files walking up toward host / umbrella non-sacred sections  
4. Optional short agent-global pointers (`~/.codex/AGENTS.md`, …)  
5. Vendor model system prompt (always present — we do **not** claim to erase it)

**Load / merge order** for tools we control: **outer → inner** (umbrella first, deepest last).

**Conflict rule:** deeper files may *narrow* scope, add local commands, or host paths. They may **never** contradict or cancel a **sacred** umbrella rule.

**Discovery gap:** many agents only load from **git root → CWD**. Nested git roots do **not** load this umbrella automatically. Inject with:

```bash
./scripts/pipe-agents.sh
# or herdr-kit:
herdr plugin action invoke tyler-jewell.herdr-kit.pipe-agents
./herdr-kit/scripts/agents-chain.sh <path-under-umbrella>
```

Core flash/recovery: **herdr-kit** (GitHub-installable; dry-run default). No product web/browser in the core kit path. See `docs/herdr-native/`.

---

## Sacred rules (every agent, every host)

1. **Dual-write law** — Every directory an agent creates for ongoing work must include both `AGENTS.md` (agents) and `README.md` (humans), unless it is pure generated/cache output.
2. **No secrets in git** — Never commit API keys, tokens, private keys, `.env` with secrets, auth dumps, session DBs, or credentials. Prefer env/secret managers.
3. **No destructive git without explicit human ask** — No force-push to shared main/master, no history rewrite of published commits, no `reset --hard` of others’ work unless the human requested it.
4. **Truth over theater** — Do not claim tests, publishes, or installs succeeded without running them. Do not hard-code fake success.
5. **Prefer reversible local work** — Prefer edits and commits that can be reviewed; confirm before irreversible shared actions (public data wipe, prod deploys, org-wide permission changes).
6. **Identity of this umbrella** — Work attributed to Tyler Jewell under this tree follows this charter first; host and project files are secondary and tertiary specialization only.
7. **Hosts registry** — Long-lived machines are recorded under `hosts/` (see `hosts/README.md`). Do not invent a second host inventory system.
8. **Pipeable charter** — This file must remain plain Markdown, free of secrets, so it can be piped or pasted into any agent/tool.
9. **Live CLI/API discovery — never hardcode enumerations that mirror a tool** — If a list, set of targets, flags, versions, hosts, or enum values is **owned by an underlying CLI or API** (and can grow/rename when that tool ships), do **not** hardcode it in our code, config, or docs as a frozen inventory. Prefer **live discovery** at runtime (`--help`, `status`, machine-readable list/JSON, OpenAPI, etc.) so when the CLI/API changes we update the tool, not every UI and script. Hand-maintained mirrors break silently or force churn. This includes **Mesh-LLM model ids and mesh peers** — discover via the OpenAI-compatible `/v1/models` (and mesh CLI), never `OFFICIAL_MODELS=…` inventories.

   **Bad (forbidden pattern):**
   ```python
   OFFICIAL_TARGETS = frozenset({
       "pi", "omp", "claude", "codex", "copilot", "devin", "droid",
       "kimi", "opencode", "kilo", "hermes", "qodercli", "cursor",
       "mastracode", "antigravity-cli", "grok",
   })
   ```
   That list belongs to `herdr integration install` / `status` (or equivalent). Parse help/status or let the CLI reject unknown targets.

   **Good:** drive UI/actions from live `herdr integration status` (or `--help` possible-values), validate only structure (safe slug), and trust the CLI as source of truth.

   **Allowed hardcoding:** our own stable policy (sacred rules, path layout we own), true constants that are not another product’s surface area, and tiny internal enums we fully control.

10. **Mesh-LLM as primary local/mesh LLM resource** — For host inference capacity, prefer Mesh-LLM’s OpenAI-compatible API (`OPENAI_BASE_URL`, default `http://127.0.0.1:9337/v1`) over ad-hoc per-tool model wiring. Install and serve through **upstream** Mesh-LLM only; do not reimplement the mesh. GPU-less hosts consume the mesh as clients. Grok cloud/product auth remains separate unless explicitly pointed at the mesh base URL.

11. **AXI alignment for every agent-invokable interface** — Any skill, tool, CLI, MCP surface, shell script, or API that **agents** run or call must stay in full alignment with the [AXI guidelines](https://axi.md) (Agent eXperience Interface). This is non-negotiable for new agent-facing surfaces and a continuous bar for owned ones. Prefer [AXI catalog](https://axi.md) wrappers (e.g. `gh-axi`) over raw human CLIs when an AXI exists. Do **not** ship new agent-facing interfaces that ignore AXI.

   **The 10 AXI principles** (see https://axi.md — source of truth):

   | # | Principle | Intent for our surfaces |
   |---|-----------|-------------------------|
   | 1 | Token-efficient output | Prefer compact TOON-like / key-minimal text over chatty prose or huge JSON dumps |
   | 2 | Minimal default schemas | 3–4 fields per list item by default; opt-in for more |
   | 3 | Content truncation | Cap large bodies; hint size; offer `--full` when needed |
   | 4 | Pre-computed aggregates | Always emit counts/status summaries agents would otherwise re-query |
   | 5 | Definitive empty states | Explicit `count: 0` / `empty: …` — never silent blank success |
   | 6 | Structured errors & exit codes | No interactive prompts; errors structured; exit 0/1/2; unknown flags fail loud (2) |
   | 7 | Ambient context | Prefer session hooks/skills that surface state without a first discovery turn |
   | 8 | Content first | No-args shows live data (or status), not only help text |
   | 9 | Contextual disclosure | Append `help[]` next-step command templates after output |
   | 10 | Consistent help | Every subcommand/entrypoint supports concise `--help` |

   Owned agent entrypoints under this umbrella (agent-kit, pipe/hierarchy helpers, herdr-kit actions) must score **10/10 on applicable principles**. Upstream binaries we do not control (`herdr`, `mesh-llm`, `gh`, …) are **not** claimed as 10/10 — prefer AXI wrappers / thin AXI adapters; document honestly. Inventory: `docs/axi/axi-scorecard.md`.

12. **herdr-kit is the isolatable Herdr methodology surface** — The stack surface meant to setup/run without inventing parallel installers is **`herdr-kit/`** (GitHub-installable Herdr plugin: flash, dry-run, wipe/bootstrap, AGENTS pipe/chain). Methodology and agent-kit **consume and contribute** to it. Do **not** reintroduce a parallel product UI under this umbrella. Each layer ships `evals/` compliance checks (≤10, do/don't policy).

13. **LSP setup and agent use of language servers** — Every project/folder that has an `AGENTS.md` must keep a **proper Language Server Protocol (LSP) setup for every language in active use** in that tree (config + public server that editors/agents can attach). **If no public LSP exists for a language, that language must not be used** in that tree. When coding, agents **MUST** use available LSP tools (diagnostics, go-to-definition, references, hover, format/rename as exposed), treat **strict** diagnostics as binding, and **must not** paper over issues with custom overrides, suppressions, or ignore directives in code or config (examples of forbidden “make it green” workarounds: `// eslint-disable`, `# noqa`, `@ts-ignore` / `@ts-expect-error` as the fix, blanket `// shellcheck disable` without fixing the root cause, turning off typechecking). Agents must identify the **root cause** of diagnostics and resolve it so the codebase stays well-maintained. Honest “LSP not available in this session” is allowed when tools are missing; shipping a tree without project LSP setup for languages it uses is **not**. Declare languages + public LSP names in each tree’s `AGENTS.md` (live project declaration — not a frozen global language allowlist). See `docs/lsp/README.md`.

   **This umbrella tree (languages in active use):**

   | Language | Public LSP |
   |----------|------------|
   | Bash (`scripts/`, `evals/`, `agent-kit/`) | [bash-language-server](https://github.com/bash-lsp/bash-language-server) |
   | Go (when present under this umbrella) | [gopls](https://github.com/golang/tools/tree/master/gopls) — must be on PATH from the host Nix/home-manager flake |

14. **Go only — never Python** — Agents **must not** write Python of any kind: product code, tests, one-offs, scratch, or “tmp” helpers. **Go** is the only language for **scripting** and **all backend** services under this umbrella (and for any web-app backends we own). Prefer a small Go binary or `go run` over shell when logic grows beyond thin glue. Shell remains allowed for thin CLI glue and evals that only orchestrate. **If a tree needs a backend or non-trivial script, it is Go + gopls (rule 13).** Do not add `*.py`, `pyrightconfig.json`, or Python LSPs to our trees. Upstream third-party tools may still invoke Python (e.g. a vendor hook we do not own); agents still **must not** author Python to extend them — wrap or reimplement in Go when we own the surface.

15. **Frontend stack + PWA bar + UI package** — All **frontend** code for web apps is **vanilla HTML, CSS, and JavaScript** only (no React/Vue/Svelte/Angular app frameworks as the product surface). Web apps **must** target the **latest Progressive Web App (PWA) standards** and be scored against the single source of truth before release:

   - **PWA SSoT (score here):** https://web.dev/learn/pwa  
   - **Release bar:** use Lighthouse PWA audits (and the learn/pwa checklist) so every public web app ships installable, offline-capable, and standards-aligned.

   The **only UI component package** allowed for now is **[shadcn](https://ui.shadcn.com/)** (and its official variants that still leave shipped UI as HTML/CSS/JS under our control). Do not introduce other UI kits (MUI, Bootstrap, Chakra, Ant, etc.). Prefer zero package + hand-crafted CSS when shadcn is unnecessary.

16. **WebAuthn passkeys for web auth** — All web apps and their backends that authenticate users **must** use **WebAuthn passkeys** as the auth mechanism (passwordless public-key credentials). Do not ship password-primary login, ad-hoc session cookies without WebAuthn enrollment, or parallel custom auth stacks. New public surfaces start passkey-first; existing ones migrate rather than grow a second scheme.

17. **Public hosting on Vercel** — All **public-facing** web apps, databases, MCPs, and similar internet-exposed product surfaces **are hosted on [Vercel](https://vercel.com)**. Do not invent a second primary public host for those surfaces. Local/dev and private mesh tooling may run on-host; production public URLs go through Vercel. Host Nix/home-manager flakes **must** provide the **Vercel CLI** on PATH (and document `vercel login` as a one-time human auth step, like `gh auth login`). Agents deploy/link with the CLI after the human has authenticated — never commit Vercel tokens.

18. **Requirements maturity scoring (honest, version-controlled, re-score on change)** — Every sacred requirement (rules **1–24**) carries a **current score (0–100)**, a **mode**, and a **logged commit hash** in the SSoT scorecard: [`docs/requirements/scorecard.md`](docs/requirements/scorecard.md) (process: [`docs/requirements/README.md`](docs/requirements/README.md)).

   - **100% / `mature` only** when the requirement is met by **core, version-controlled setup** that a **clean machine can replicate** (policy + implementation + proof; gaps empty). See scorecard definition of 100%.
   - **Any score &lt; 100% is `development` mode.** Agents must treat that requirement as unfinished infrastructure — not done.
   - **Objectivity / honesty:** prefer under-scoring; no theater; do not mark mature on docs-only when runtime/product behavior is required.
   - **Mandatory re-score:** any learning, update, bugfix, issue found, or refinement that **affects** a scored requirement **must** update the scorecard (score, mode, evidence, gaps, commit hashes, rescore log) in the same change set when possible.
   - **Public gate:** we do **not** declare this overall setup finished / ready for public completion until **every** requirement is **100% / mature**. While the gate is **BLOCKED**, do not claim full maturity.

19. **DRY — single source of truth (stop the multi-file copy edit)** — **Do not repeat yourself.** Every agent working on code (or config/docs that encode the same fact twice) must stay on the lookout for duplicated knowledge.

   - **Trigger:** if a single logical change requires updating the **same fact, list, rule, schema, constant, path, version, or behavior** in a **second** file — and especially a **third** — **STOP**. Do not grind through N copies.
   - **Then:** fully map **usage** (who reads it, who owns it, what is derived vs source), choose or create a **single source of truth (SSoT)** that matches our standards (version-controlled, live discovery when the surface is owned by a CLI/API — rule 9, dual-write AGENTS/README only for role split not content clone, pipeable charters, etc.).
   - **Push the SSoT:** consolidate so other call sites **import, reference, generate, or discover** — they do not hand-maintain a parallel copy. Delete or thin the duplicates in the same change set when safe.
   - **On everyone:** humans and agents alike; filing a “found duplication” note and fixing it is first-class work, not a distraction.
   - **Not DRY violations:** intentional dual-write of *different audiences* (AGENTS vs README), thin wrappers, or generated output from an SSoT (as long as generation is the only edit path).

20. **Simplicity first — tests must not drive tech debt (stop and fix)** — Anytime you are **creating new code** or **updating existing code**, ask yourself, out loud in the work if needed:

   1. **Could this be simpler?**
   2. **Are tests (or evals, fixtures, mocks, “make CI green” scaffolding) driving tech debt** — forcing awkward APIs, copy-paste setup, leaky abstractions, or production shapes that exist only to satisfy the harness?

   - **If yes to either in a material way:** this is a **STOP and fix** situation — **same urgency as DRY (rule 19)**. Do not push complexity forward “to finish the task.”
   - **Then:** simplify the design, collapse layers, delete dead paths, rewrite tests so they **protect behavior** without dictating a worse product shape, or thin the surface until the honest answer is “this is as simple as the problem allows.”
   - **On everyone:** agents and humans stay on the lookout during new work **and** refactors of old code. Prefer fewer concepts, fewer files, fewer flags, and direct code over cleverness.
   - **Not an excuse** to skip necessary tests, sacred evals, or safety checks — tests serve the product; the product does not contort to serve brittle tests.

21. **Instruction authority chain (umbrella supreme; full AGENTS chain)** — For every agent session under the Tyler Jewell identity (including agents started or supervised through **Herdr**), the **sacred rules in this file** are the **highest-priority project instruction layer**. They outrank host and project `AGENTS.md` files, agent-global instruction files, and any “closest AGENTS only” default when those would cancel sacred rules.

   - **Chain:** Resolve every `AGENTS.md` from the **umbrella root along the work path to CWD** (tools: `hierarchy-order.sh`, herdr-kit `agents-chain` / `pipe-agents`). **Load outer→inner.**
   - **Conflict:** deeper files may *specialize*; they may **never** contradict or cancel a sacred umbrella rule.
   - **Honesty:** Vendor model system prompts remain; we do not claim to erase them. Explicit **human chat** for the current turn still outranks docs (industry standard). Nested git roots do **not** auto-load parents — agents **must** inject this charter when the session root is outside this repo.
   - **Herdr:** Herdr is the **runtime** only. **herdr-kit** owns flash, dry-run, wipe/bootstrap helpers, and pipe/chain actions. Do not invent Herdr system-prompt hacks.
   - **Core path:** herdr-kit only for methodology flash/authority — no product web UI required. See `docs/herdr-native/` and `herdr-kit/`.

22. **Never hardcode local app ports — claim them in `ports.toml`** — Many local web apps may run at once. Agents **must not** hardcode listen ports (or sticky URLs like `http://127.0.0.1:8765/`) in docs, READMEs, AGENTS text, scripts, or code defaults as if a number were universal.

   - **SSoT:** Every directory that has an `AGENTS.md` **must** include a sibling **`ports.toml`** that **claims** which ports (if any) local web apps in that folder use, and for what.
   - **Empty claims are fine** when the tree has no local HTTP(S) apps — still ship `ports.toml` with no `[[port]]` rows (or an explicit comment that claims are empty).
   - **Before choosing a port:** read this tree’s `ports.toml` and parent claims when relevant; pick a free claim; **update `ports.toml` first**, then wire env/flags/code to **read the claim** (env override still allowed for one-off runs).
   - **Docs/UI copy:** describe how to discover the URL (env, status output, ports.toml) — never teach a frozen port as the only answer.
   - **Bad:** sticky “open http://127.0.0.1:&lt;fixed-port&gt;/…” as the only instruction for a UI.
   - **Good:** claim in `ports.toml`, bind via env / loader from that claim, print the live URL at serve time; docs say “see `ports.toml` / serve status line.”
   - **Not this rule:** documenting an **upstream** product’s well-known default (e.g. Mesh-LLM’s published default base URL) with env override — still prefer env/`ports.toml` when **we** host the process. See `docs/ports/README.md`.

23. **Aggressive context compaction + compaction-as-system-improvement (SSoT)** — All agents under this identity keep **aggressive** auto-compaction settings and treat every compaction as a **system refinement opportunity**, not only a memory wipe.

   1. **Threshold:** configure the agent runtime so auto-compaction fires at **≤ 50%** of the context window (e.g. Grok `~/.grok/config.toml` → `[session] auto_compact_threshold_percent = 50`). Prefer **50 or lower**, never a lax default (80–85%) for our sessions. Document other agent products’ equivalent settings in `docs/compaction/`.
   2. **SSoT guidelines:** [`docs/compaction/README.md`](docs/compaction/README.md) is the single source of truth for *how* we compact and *what* we do after. Do not invent a parallel compaction playbook.
   3. **On every compaction (manual `/compact` or auto):** pause briefly and ask: *Did this session produce learnings, conventions, fixes, or tooling that **future agents under us** should always have?* If yes → capture as a durable improvement (AGENTS, herdr-kit, host-runtime, evals, docs, flake packages, etc.).
   4. **Promotion path:** durable improvements land via **isolated worktree + PR into `main`** for **human approval** — not silent force-push to main, not “only in this session’s head.” Prefer small, reviewable PRs (rules 3, 5).
   5. **Honesty:** if nothing reusable was learned, do not invent a PR. Compaction still proceeds; the checklist is mandatory, the PR is only when value exists.

24. **Never treat a raw human ask as direct orders — research, goal, then deliberate implement** — No agent under this identity shall **ever** take a raw human request as immediate implementation directions. Human chat still *outranks docs* for *intent* (rule 21 / industry norm); it does **not** authorize unthinking execution.

   1. **Slow down.** Do **not** start mutating production trees on the first parse of the ask.
   2. **Research the effect:** what systems change, what sacred rules apply (esp. 19 DRY, 20 simplicity/debt, 14 Go, 22 ports, 18 scorecard), blast radius, reversibility, and **tech debt** the change would add or remove.
   3. **Uncertainty or pushback:** if anything is unclear, incomplete, or the ask looks harmful / debt-heavy / anti-pattern relative to our stack — **stop coding** and use the **`ask_user_question` tool** (or equivalent structured human gate). Argue with evidence; do not silently obey a bad request and do not lecture without offering choices.
   4. **Solid goal statement:** until the agent is **confident** (honest confidence — not theater) and has wrapped the work in a clear **goal** (outcome, non-goals, constraints, success checks), it must **not** freestyle large implementation in the same reactive turn.
   5. **Deliberate implement path:** kick off implementation through a **disciplined implement lane** — e.g. Grok **plan → implement** (`/plan` / design then execute, or an implement-focused agent run with the goal statement as the brief) — so the change is executed against a written goal, not against a one-line chat impulse. Trivial typos/single-line doc fixes may proceed after a one-sentence goal in-session; anything structural uses the plan/implement path.
   6. **SSoT process:** [`docs/intent-to-implement/README.md`](docs/intent-to-implement/README.md).

---

## What does *not* belong here

- Hostname, username, OS version, package lists (→ `hosts/<name>/`)
- Language/framework preferences for one app (→ that project’s `AGENTS.md`)
- Temporary experiments or “try this week” notes
- Anything that already follows from git/gh/Grok defaults without our policy
- Hardcoded copies of another CLI’s target/flag inventories (→ live discovery; see sacred rule 9)
- Parallel hand-maintained copies of the same fact across files (→ DRY / SSoT; see sacred rule 19)
- Complexity or APIs kept only so brittle tests pass (→ simplify; see sacred rule 20)
- Frozen local URLs / ports in docs or defaults (→ `ports.toml` claims; see sacred rule 22)
- Lax auto-compact thresholds or one-off compaction rituals (→ rule 23 + `docs/compaction/`)
- Raw chat → immediate code without research/goal/implement lane (→ rule 24 + `docs/intent-to-implement/`)

---

## Hierarchy tools

| Command | Purpose |
|---------|---------|
| `./scripts/pipe-agents.sh` | Print this umbrella AGENTS.md only (stdout) |
| `./scripts/hierarchy-order.sh <path>` | List every `AGENTS.md` from umbrella root → path (authoritative outer→inner order) |
| `./test/run-hierarchy-check.sh` | Prove depth≥3 chain order on the in-repo fixture |

---

## Human map

See `README.md` for clone, publish, and host registration.
