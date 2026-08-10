# tyler-jewell

Public **identity umbrella** and methodology for Tyler Jewell agent work across machines.  
This is a normal GitHub repo — **not** the OS home directory and not a dump of private absolute paths.

Core Herdr surface: **`herdr-kit/`** (flash, dry-run, wipe/bootstrap, AGENTS pipe/chain).

## Manual prerequisites (human — before agents run the process)

Do these **before** AI-first setup, publish, or multi-repo work. Agents must not invent credentials.

| Order | Step | Notes |
|------:|------|--------|
| **1** | **`gh auth login`** | **Required early.** Browser/device OAuth for GitHub CLI. Without it, inventory, `gh repo create`, and push fail. |
| 2 | `sudo …/privileged-setup.sh` (or Determinate Nix GUI) | Once per wiped Mac — CLT + Nix volume |
| 3 | `grok login` (if needed) | Grok account/API; separate from GitHub |

Cloning public repos with plain `git clone` does not need `gh auth`. **Creating/pushing** private or org repos does.

## Sacred overall AGENTS

[`AGENTS.md`](AGENTS.md) is overall/primary. Host and project `AGENTS.md` files specialize; they never override sacred rules.

### Pipe into any tool

```bash
# From a local checkout (any path):
./scripts/pipe-agents.sh
# or:
cat AGENTS.md

# Public raw (after this repo is public):
curl -fsSL https://raw.githubusercontent.com/tyler-jewell/tyler-jewell/main/AGENTS.md
```

## Layout

```
tyler-jewell/
  AGENTS.md                 # sacred umbrella (overall)
  README.md
  scripts/                  # pipe-agents, hierarchy-order
  agent-kit/                # AI-first setup after Nix floor
  hosts/
    macbook-pro/            # primary laptop host class (portable docs)
    mac-studio/             # Studio SSH parity template
  test/run-hierarchy-check.sh
```

Paths in docs use **`$HOME`**, **`~`**, and **relative** repo paths so the methodology works on any username or clone location.

## Hierarchy (authoritative order)

1. `AGENTS.md` (umbrella — sacred)
2. `hosts/<host>/AGENTS.md`
3. Deeper project `AGENTS.md` files

```bash
./test/run-hierarchy-check.sh
./scripts/hierarchy-order.sh hosts/macbook-pro/projects/_hierarchy-probe
```

## Hosts

Register machines under `hosts/<slug>/`. Public examples: **macbook-pro**, **mac-studio**.  
Full-setup targets need live **LLM-capable GPU** discovery (see agent-kit).

## AI-first agent kit

After Nix exists on a machine:

```bash
./agent-kit/scripts/ai-first-setup.sh --dry-run
./agent-kit/test/run-tests.sh
```

### LSP when coding

Sacred **rule 13**: every tree with `AGENTS.md` keeps public LSP setup for languages it uses; agents **MUST** use LSP tools; no suppressions-as-fix; root-cause only. Guide: [docs/lsp/README.md](docs/lsp/README.md).

### Stack non-negotiables (rules 14–17)

| Rule | Bar |
|------|-----|
| **14 Go only** | No Python (not even tmp). Scripting + all backends are **Go**. Host flake: `go` + **gopls**. |
| **15 Frontend + PWA** | Vanilla **HTML/CSS/JS**; score PWAs at **https://web.dev/learn/pwa**; only UI package: **shadcn**. |
| **16 Passkeys** | WebAuthn passkeys for web app auth. |
| **17 Vercel** | Public web apps / DBs / MCPs on **Vercel**; flake installs CLI; human **`vercel login`**. |

### DRY / SSoT (rule 19)

If a single change needs the **same fact** updated in a **second** (or **third**) file — **stop**, map usage, and push a **single source of truth**. Everyone is on the lookout; do not grind N copies.

### Simplicity / tests vs debt (rule 20)

On every create or update: **Could this be simpler?** **Are tests driving tech debt?** If yes → **stop and fix** (same bar as DRY). Tests protect behavior; they must not force worse product shape.

### Instruction authority + herdr-kit (rule 21)

Sacred umbrella wins among project instruction layers; load AGENTS **outer→inner**. Core tooling: **`herdr-kit/`** (flash dry-run default, wipe/bootstrap, pipe-agents). See [docs/herdr-native/](docs/herdr-native/). Multi-host only after Mac soak.

### Local ports (rule 22)

**Never hardcode** local app ports / sticky `http://127.0.0.1:NNNN/` in docs. Every `AGENTS.md` directory has **`ports.toml`** claims. See [docs/ports/](docs/ports/).

### Compaction (rule 23)

Auto-compact at **≤ 50%** context. Every compact is a chance to **promote reusable learnings** via **worktree + PR to `main`** (human approval). SSoT: [docs/compaction/](docs/compaction/).

### Requirements maturity (rule 18) — public gate

Every sacred requirement has an **honest score**, **mode** (`development` unless 100%), and **commit hash** in:

**[docs/requirements/scorecard.md](docs/requirements/scorecard.md)** · process: [docs/requirements/README.md](docs/requirements/README.md)

- **&lt; 100% ⇒ development** — agents must re-score when they change anything that affects a requirement.
- **Public gate BLOCKED** until **all** requirements are **100% / mature** (version-controlled, clean-machine replicable). Do not claim the core setup is finished while blocked.

### AXI (agent-facing CLIs)

Every agent-runnable skill/tool/CLI/MCP we ship must follow **[AXI](https://axi.md)** (sacred rule 11).  
Scorecard: [docs/axi/axi-scorecard.md](docs/axi/axi-scorecard.md). Preferred compact status:

```bash
./agent-kit/scripts/agent-status.sh
```

### Mesh-LLM (primary local/mesh LLM layer)

[Mesh-LLM](https://github.com/Mesh-LLM/mesh-llm) is the default **OpenAI-compatible** inference resource for hosts (`http://127.0.0.1:9337/v1`). Agent-kit reports live availability; install/serve via upstream CLI only. **No frozen model lists** — discover with `curl -s "$OPENAI_BASE_URL/models"`.

See [agent-kit/README.md](agent-kit/README.md). Studio SSH parity: [hosts/mac-studio/](hosts/mac-studio/).

## herdr-kit (isolatable Herdr methodology)

```bash
herdr plugin link ./herdr-kit
herdr plugin action invoke tyler-jewell.herdr-kit.status
herdr plugin action invoke tyler-jewell.herdr-kit.flash   # dry-run default
```

### Layered compliance evals (≤10 each)

| Layer | Path |
|-------|------|
| Methodology | `evals/` |
| Agent-kit | `agent-kit/evals/` |
| herdr-kit | `herdr-kit/evals/` |

```bash
./evals/run.sh run
./agent-kit/evals/run.sh run
./herdr-kit/scripts/evals.sh run
```

## Publish

Requires **`gh auth login` already completed** (see prerequisites above).

```bash
gh repo create tyler-jewell/tyler-jewell --public --source=. --remote=origin --push
```

Do **not** force-push. Never publish secrets or private absolute home paths.
