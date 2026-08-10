# tyler-jewell

Public **identity umbrella** and methodology for Tyler Jewell agent work across machines.  
This is a normal GitHub repo — **not** the OS home directory and not a dump of private absolute paths.

Related product: **[herdr-web](https://github.com/tyler-jewell/herdr-web)** — Integrations UI (clone + `./scripts/serve.sh`).

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

## herdr-web (separate public repo)

```bash
git clone https://github.com/tyler-jewell/herdr-web.git
cd herdr-web && ./scripts/serve.sh
# → http://127.0.0.1:8765/
```

## Publish

```bash
# methodology umbrella (this repo)
gh repo create tyler-jewell/tyler-jewell --public --source=. --remote=origin --push

# Integrations UI (sibling product)
# see herdr-web README — two steps: clone + ./scripts/serve.sh
```

Do **not** force-push. Never publish secrets or private absolute home paths.
