# tyler-jewell

Starter kit and **identity umbrella** for Tyler Jewell agent work across machines.  
This is a **normal GitHub repo**, not the OS home directory.

## Sacred overall AGENTS

[`AGENTS.md`](AGENTS.md) is overall/primary. Host and project `AGENTS.md` files specialize; they never override sacred rules.

### Pipe into any tool

```bash
# Local checkout:
cat ~/github-repos/tyler-jewell/AGENTS.md
# or:
~/github-repos/tyler-jewell/scripts/pipe-agents.sh

# After GitHub publish (private raw needs auth):
gh api repos/OWNER/tyler-jewell/contents/AGENTS.md --jq .content | base64 -d
# or public raw URL if the repo is public:
# curl -fsSL https://raw.githubusercontent.com/OWNER/tyler-jewell/main/AGENTS.md
```

## Layout

```
tyler-jewell/
  AGENTS.md                 # sacred umbrella (overall)
  README.md
  scripts/
    pipe-agents.sh          # emit umbrella AGENTS only
    hierarchy-order.sh      # outer→inner AGENTS chain for a path
  hosts/
    AGENTS.md / README.md   # hosts registry
    tylers-macbook-pro/     # first host
      AGENTS.md / README.md
      host.toml
      projects/_hierarchy-probe/   # depth fixture for hierarchy proof
        AGENTS.md / README.md
  test/
    run-hierarchy-check.sh
```

## Hierarchy (authoritative order)

For a working directory under this repo, agents must honor:

1. `tyler-jewell/AGENTS.md` (umbrella — sacred)
2. `hosts/<host>/AGENTS.md` (when under that host tree)
3. Deeper project `AGENTS.md` files (specialization)

Prove with:

```bash
./test/run-hierarchy-check.sh
./scripts/hierarchy-order.sh hosts/tylers-macbook-pro/projects/_hierarchy-probe
```

## Hosts

Register each long-lived machine under `hosts/<slug>/`. First host: **tylers-macbook-pro** (Tylers-MacBook-Pro / user `mbp`).

## Publish to GitHub

`gh` must be logged in first:

```bash
gh auth login
cd ~/github-repos/tyler-jewell
gh repo create tyler-jewell --private --source=. --remote=origin --push
# or under an org:
# gh repo create ORG/tyler-jewell --private --source=. --remote=origin --push
```

Do **not** force-push. Prefer private until you intentionally open the charter.

## Verify hierarchy

```bash
./test/run-hierarchy-check.sh
```
