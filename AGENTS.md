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
