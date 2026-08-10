# Skills / agents access controls by layer

## Layers

| Layer | Repo | Agents own | Must not |
|-------|------|------------|----------|
| **herdr-web** (isolatable product) | `tyler-jewell/herdr-web` | Plugin, UI, serve/HMR, product evals | Require home-admin tree; hardcode integration lists; secrets |
| **Methodology umbrella** | `tyler-jewell/tyler-jewell` | Sacred AGENTS, hosts templates, layer evals, docs | Replace herdr-web with a second UI product |
| **Agent-kit** | under umbrella | Discovery, mesh/herdr status, AXI status CLI, kit evals | Curl reinstall Grok/Herdr/Mesh; invent GPU hosts |
| **Home/system admin** | machine `$HOME` sparse git | Local apply, privileged once | Force-push; osascript elevation; publish secrets |

## Skills

| Skill | Location | Access |
|-------|----------|--------|
| `ai-first-host-setup` | `agent-kit/skills/` | Read/run on host after Nix; mutations need approval (`--apply --yes` / ask_user_question) |

## Evals

- **Purpose:** compliance do/don't, not adversarial challenges.
- **Cap:** ≤10 per layer.
- **Herdr entry:** herdr-web plugin actions `evals-list` / `evals-run`.

## Controls checklist for agents

1. `gh auth login` already done by human before publish.
2. Prefer `herdr plugin link` for herdr-web side-by-side dev.
3. Prefer `agent-status.sh` (AXI) for kit status.
4. Never commit secrets; never hardcode tool enums (sacred rules 2, 9, 11, 12).
