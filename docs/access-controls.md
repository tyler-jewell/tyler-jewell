# Access controls

| Surface | Repo / path | Agents may | Must not |
|---------|-------------|------------|----------|
| **herdr-kit** | `tyler-jewell/herdr-kit` | Flash, status, pipe/chain, wipe/bootstrap (dry-run default) | Secrets; invent always-on without human ask |
| **Methodology umbrella** | `tyler-jewell/tyler-jewell` | Sacred AGENTS, hosts, evals, docs | Parallel installers; product web UI under umbrella |
| **Host system** | `$HOME/system` | HM packages, host-runtime.toml | Privilege elevation without human |

## Evals

- Umbrella: `evals/`
- Agent-kit: `agent-kit/evals/`
- herdr-kit: `herdr-kit/evals/` or `herdr plugin action invoke tyler-jewell.herdr-kit.evals-run`

## Dev notes

1. Prefer `herdr plugin link` for herdr-kit side-by-side dev.
2. Config-first: desired plugins in `herdr-kit/config/plugins.desired.toml` and/or `system/files/herdr/plugins.desired.toml`.
