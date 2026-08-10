# Herdr-native core (flash, dry-run, wipe/reinstall)

Canon: umbrella **AGENTS.md rule 21** + **herdr-kit**.

## Scope

| In | Out |
|----|-----|
| herdr-kit plugin, desired config, flash | herdr-web / Integrations UI |
| pipe-agents / agents-chain | Browser panes / Chromium |
| dry-run default, graduated wipe, bootstrap | Multi-host until Mac soak green |
| MacBook Pro soak cycles | Product PWA / passkeys / Vercel deploys |

## Consumer path

```bash
# Install or link
herdr plugin install tyler-jewell/tyler-jewell/herdr-kit --yes
# dev:
herdr plugin link "$HOME/github-repos/tyler-jewell/herdr-kit"

herdr plugin action invoke tyler-jewell.herdr-kit.status
herdr plugin action invoke tyler-jewell.herdr-kit.flash          # dry-run default
herdr plugin action invoke tyler-jewell.herdr-kit.flash -- --apply
```

## Modes

| Mode | Flag | Writes? |
|------|------|---------|
| Dry-run | default (no `--apply`) | No |
| Apply | `--apply` | Yes |
| Destructive | wipe/nuke need `--apply --yes` + `--level` | Yes |

## Soak (this Mac only before multi-host)

See `herdr-kit/README.md`. Gate: soft ×3, herdr ×2, agents ×2, agents+purge-auth ×1.

## Never wipe

`/nix`, `~/system`, `~/github-repos/tyler-jewell`, SSH keys.
