# herdr-kit

GitHub-installable **core** Herdr plugin for Tyler Jewell methodology.

- Flash desired Herdr config from version control  
- **Dry-run by default**  
- Graduated wipe → bootstrap (prove cold path)  
- Pipe / chain sacred AGENTS  

**Not included:** herdr-web, browser panes.

## Install

```bash
herdr plugin install tyler-jewell/tyler-jewell/herdr-kit --yes
# local dev:
herdr plugin link /path/to/tyler-jewell/herdr-kit
```

## Actions

| Action | Safe? | Notes |
|--------|-------|-------|
| `status` | yes | Live summary |
| `pipe-agents` | yes | Sacred AGENTS.md |
| `agents-chain` | yes | Pass path: `… agents-chain -- hosts/macbook-pro` |
| `flash` | dry-run default | `--apply` writes config |
| `wipe` | dry-run default | `--level soft\|herdr\|agents` + `--apply --yes` |
| `bootstrap` | dry-run default | Reinstall kit + flash |
| `cycle` | dry-run default | wipe → bootstrap → status |
| `evals-list` / `evals-run` | yes | Kit + umbrella evals |

```bash
herdr plugin action invoke tyler-jewell.herdr-kit.flash
herdr plugin action invoke tyler-jewell.herdr-kit.flash -- --apply
herdr plugin action invoke tyler-jewell.herdr-kit.wipe -- --level soft
herdr plugin action invoke tyler-jewell.herdr-kit.wipe -- --level soft --apply --yes
```

## MacBook Pro soak (before multi-host)

1. Soft cycle ×3 with `--apply --yes`  
2. Herdr-level cycle ×2  
3. Agents-level cycle ×2 (auth preserved)  
4. Agents + `--purge-auth` ×1 (human re-login Grok once)  

Log results in `hosts/macbook-pro/soak-log.md` (no secrets).

## Never wipe

Nix, `~/system`, tyler-jewell git clone, SSH keys.
