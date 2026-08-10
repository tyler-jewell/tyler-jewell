# Tyler Jewell — umbrella charter (sacred)

You are operating under the **Tyler Jewell** umbrella. This file is the **overall / primary** agent charter for all machines, hosts, and projects under this identity.

**Sacred:** do not add, edit, or weaken these rules lightly. Change only when certain that (1) the rule will remain true for years, (2) every agent under Tyler Jewell must follow it, and (3) tool defaults do not already enforce it.

---

## Authority order (overall → specialization)

When multiple `AGENTS.md` files apply, treat them as a chain:

1. **This file (umbrella)** — overall identity and non-negotiable rules for Tyler Jewell.
2. **Host** — machine-specific admin (`hosts/<host>/AGENTS.md`).
3. **Project / deeper trees** — product or folder specialization.

**Conflict rule:** specialization may *narrow* scope, add local conventions, or describe host paths. It may **never** contradict or cancel a sacred umbrella rule. (Product loaders may show deeper files later in context; sacred rules still win.)

Grok (and similar tools) discover rules from a **git repo root toward CWD**. Nested git roots do **not** automatically load parent folders. When a session is outside this repo, inject this charter with:

```bash
# from any machine with this repo checked out:
cat path/to/tyler-jewell/AGENTS.md
# or:
./scripts/pipe-agents.sh
```

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

   Owned agent entrypoints under this umbrella (agent-kit, pipe/hierarchy helpers, herdr-web bridge agents invoke) must score **10/10 on applicable principles**. Upstream binaries we do not control (`herdr`, `mesh-llm`, `gh`, …) are **not** claimed as 10/10 — prefer AXI wrappers / thin AXI adapters; document honestly. Inventory: `docs/axi/axi-scorecard.md`.

12. **herdr-web is the isolatable UI product** — The only stack surface meant to be setup/run without the full umbrella is **[herdr-web](https://github.com/tyler-jewell/herdr-web)** (Herdr plugin + hot-reload Integrations UI). Methodology and agent-kit **consume and contribute** to it; do not invent a parallel web product. Each layer ships `evals/` compliance checks (≤10, do/don't policy).

13. **LSP setup and agent use of language servers** — Every project/folder that has an `AGENTS.md` must keep a **proper Language Server Protocol (LSP) setup for every language in active use** in that tree (config + public server that editors/agents can attach). **If no public LSP exists for a language, that language must not be used** in that tree. When coding, agents **MUST** use available LSP tools (diagnostics, go-to-definition, references, hover, format/rename as exposed), treat **strict** diagnostics as binding, and **must not** paper over issues with custom overrides, suppressions, or ignore directives in code or config (examples of forbidden “make it green” workarounds: `// eslint-disable`, `# noqa`, `@ts-ignore` / `@ts-expect-error` as the fix, blanket `// shellcheck disable` without fixing the root cause, turning off typechecking). Agents must identify the **root cause** of diagnostics and resolve it so the codebase stays well-maintained. Honest “LSP not available in this session” is allowed when tools are missing; shipping a tree without project LSP setup for languages it uses is **not**. Declare languages + public LSP names in each tree’s `AGENTS.md` (live project declaration — not a frozen global language allowlist). See `docs/lsp/README.md`.

   **This umbrella tree (languages in active use):**

   | Language | Public LSP |
   |----------|------------|
   | Bash (`scripts/`, `evals/`, `agent-kit/`) | [bash-language-server](https://github.com/bash-lsp/bash-language-server) |
   | Go (when present under this umbrella) | [gopls](https://github.com/golang/tools/tree/master/gopls) — must be on PATH from the host Nix/home-manager flake |

14. **Go only — never Python** — Agents **must not** write Python of any kind: product code, tests, one-offs, scratch, or “tmp” helpers. **Go** is the only language for **scripting** and **all backend** services under this umbrella (and for herdr-web / web-app backends). Prefer a small Go binary or `go run` over shell when logic grows beyond thin glue. Shell remains allowed for thin CLI glue and evals that only orchestrate. **If a tree needs a backend or non-trivial script, it is Go + gopls (rule 13).** Do not add `*.py`, `pyrightconfig.json`, or Python LSPs to our trees. Upstream third-party tools may still invoke Python (e.g. a vendor hook we do not own); agents still **must not** author Python to extend them — wrap or reimplement in Go when we own the surface.

15. **Frontend stack + PWA bar + UI package** — All **frontend** code for web apps is **vanilla HTML, CSS, and JavaScript** only (no React/Vue/Svelte/Angular app frameworks as the product surface). Web apps **must** target the **latest Progressive Web App (PWA) standards** and be scored against the single source of truth before release:

   - **PWA SSoT (score here):** https://web.dev/learn/pwa  
   - **Release bar:** use Lighthouse PWA audits (and the learn/pwa checklist) so every public web app ships installable, offline-capable, and standards-aligned.

   The **only UI component package** allowed for now is **[shadcn](https://ui.shadcn.com/)** (and its official variants that still leave shipped UI as HTML/CSS/JS under our control). Do not introduce other UI kits (MUI, Bootstrap, Chakra, Ant, etc.). Prefer zero package + hand-crafted CSS when shadcn is unnecessary.

16. **WebAuthn passkeys for web auth** — All web apps and their backends that authenticate users **must** use **WebAuthn passkeys** as the auth mechanism (passwordless public-key credentials). Do not ship password-primary login, ad-hoc session cookies without WebAuthn enrollment, or parallel custom auth stacks. New public surfaces start passkey-first; existing ones migrate rather than grow a second scheme.

17. **Public hosting on Vercel** — All **public-facing** web apps, databases, MCPs, and similar internet-exposed product surfaces **are hosted on [Vercel](https://vercel.com)**. Do not invent a second primary public host for those surfaces. Local/dev and private mesh tooling may run on-host; production public URLs go through Vercel. Host Nix/home-manager flakes **must** provide the **Vercel CLI** on PATH (and document `vercel login` as a one-time human auth step, like `gh auth login`). Agents deploy/link with the CLI after the human has authenticated — never commit Vercel tokens.

18. **Requirements maturity scoring (honest, version-controlled, re-score on change)** — Every sacred requirement (rules **1–19**) carries a **current score (0–100)**, a **mode**, and a **logged commit hash** in the SSoT scorecard: [`docs/requirements/scorecard.md`](docs/requirements/scorecard.md) (process: [`docs/requirements/README.md`](docs/requirements/README.md)).

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

---

## What does *not* belong here

- Hostname, username, OS version, package lists (→ `hosts/<name>/`)
- Language/framework preferences for one app (→ that project’s `AGENTS.md`)
- Temporary experiments or “try this week” notes
- Anything that already follows from git/gh/Grok defaults without our policy
- Hardcoded copies of another CLI’s target/flag inventories (→ live discovery; see sacred rule 9)
- Parallel hand-maintained copies of the same fact across files (→ DRY / SSoT; see sacred rule 19)

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
