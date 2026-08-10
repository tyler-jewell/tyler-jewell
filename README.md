# tyler-jewell

Public **identity umbrella** and methodology for Tyler Jewell agent work across machines.  
This is a normal GitHub repo — **not** the OS home directory and not a dump of private absolute paths.

Related product: **[herdr-web](https://github.com/tyler-jewell/herdr-web)** — Integrations UI (clone + `./scripts/serve.sh`).

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

### AXI (agent-facing CLIs)

Every agent-runnable skill/tool/CLI/MCP we ship must follow **[AXI](https://axi.md)** (sacred rule 11).  
Scorecard: [docs/axi/axi-scorecard.md](docs/axi/axi-scorecard.md). Preferred compact status:

```bash
./agent-kit/scripts/agent-status.sh
```

### Mesh-LLM (primary local/mesh LLM layer)

[Mesh-LLM](https://github.com/Mesh-LLM/mesh-llm) is the default **OpenAI-compatible** inference resource for hosts (`http://127.0.0.1:9337/v1`). Agent-kit reports live availability; install/serve via upstream CLI only. **No frozen model lists** — discover with `curl -s "$OPENAI_BASE_URL/models"`.

See [agent-kit/README.md](agent-kit/README.md). Studio SSH parity: [hosts/mac-studio/](hosts/mac-studio/).

## herdr-web (only isolatable product)

Shared Integrations UI as a **Herdr plugin** (hot-reload by default). Core layers consume/contribute — no second UI.

```bash
git clone https://github.com/tyler-jewell/herdr-web.git
cd herdr-web
./scripts/serve.sh                    # isolation (2 steps)
# or side-by-side in Herdr:
herdr plugin link .
herdr plugin pane open --plugin tyler-jewell.herdr-web --entrypoint integrations
```

### Layered compliance evals (≤10 each)

| Layer | Path |
|-------|------|
| Methodology | `evals/` |
| Agent-kit | `agent-kit/evals/` |
| herdr-web | (in herdr-web repo) `evals/` |

```bash
./evals/run.sh run
./agent-kit/evals/run.sh run
# multi-layer via plugin:
HERDR_EVALS_LAYERS="$PWD/evals:$PWD/agent-kit/evals" \
  bash ../herdr-web/scripts/evals.sh run
```

## Publish

Requires **`gh auth login` already completed** (see prerequisites above).

```bash
# methodology umbrella (this repo)
gh repo create tyler-jewell/tyler-jewell --public --source=. --remote=origin --push

# Integrations UI (sibling product)
# see herdr-web README — two steps: clone + ./scripts/serve.sh
```

Do **not** force-push. Never publish secrets or private absolute home paths.
