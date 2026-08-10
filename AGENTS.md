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
10. **Mesh-LLM as primary local/mesh LLM resource** — For host inference capacity, prefer Mesh-LLM’s OpenAI-compatible API (`OPENAI_BASE_URL`, default `http://127.0.0.1:9337/v1`) over ad-hoc per-tool model wiring. Install and serve through **upstream** Mesh-LLM only; do not reimplement the mesh. GPU-less hosts consume the mesh as clients. Grok cloud/product auth remains separate unless explicitly pointed at the mesh base URL.
11. **AXI alignment for every agent-invokable interface** — Any skill, tool, CLI, MCP surface, shell script, or API that **agents** run or call must stay in full alignment with the [AXI guidelines](https://axi.md) (Agent eXperience Interface). This is non-negotiable for new agent-facing surfaces and a continuous bar for owned ones. Prefer [AXI catalog](https://axi.md) wrappers (e.g. `gh-axi`) over raw human CLIs when an AXI exists. Do **not** ship new agent-facing interfaces that ignore AXI.
12. **herdr-web is the isolatable UI product** — The only stack surface meant to be setup/run without the full umbrella is **[herdr-web](https://github.com/tyler-jewell/herdr-web)** (Herdr plugin + hot-reload Integrations UI). Methodology and agent-kit **consume and contribute** to it; do not invent a parallel web product. Each layer ships `evals/` compliance checks (≤10, do/don't policy).

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

---

## What does *not* belong here

- Hostname, username, OS version, package lists (→ `hosts/<name>/`)
- Language/framework preferences for one app (→ that project’s `AGENTS.md`)
- Temporary experiments or “try this week” notes
- Anything that already follows from git/gh/Grok defaults without our policy
- Hardcoded copies of another CLI’s target/flag inventories (→ live discovery; see sacred rule 9)

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
