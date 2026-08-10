# mac-studio (template)

Bring a Mac Studio to the same AI-first stack as a MacBook Pro host, **after** human permission and working SSH.

## Human prerequisites (exact)

```bash
# 1) On Studio: create user, enable Remote Login (SSH)
# 2) From your laptop — replace alias/user/host as needed:
ssh-copy-id user@mac-studio.local
ssh user@mac-studio.local 'hostname; uname -m'

# 3) If Studio has no Nix yet (human once on Studio):
ssh -t user@mac-studio.local 'sudo "$HOME/system/scripts/privileged-setup.sh"'
# (after seeding system/ + tyler-jewell trees into $HOME)

# 4) Seed methodology + herdr-web (example patterns — adjust clone root):
#    git clone https://github.com/tyler-jewell/tyler-jewell.git "$HOME/github-repos/tyler-jewell"
#    git clone https://github.com/tyler-jewell/herdr-web.git "$HOME/github-repos/herdr-web"

# 5) Agent dry-run on Studio:
ssh user@mac-studio.local '"$HOME/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh" --dry-run'

# 6) After approval:
ssh user@mac-studio.local '"$HOME/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh" --apply --yes --propose-host'
```

## Same-as-MacBook checklist

- [ ] Umbrella `tyler-jewell` AGENTS present under a clone path you choose
- [ ] Nix + home-manager apply
- [ ] `herdr` on PATH; `herdr config check`; integrations via live status
- [ ] herdr-web: `./scripts/serve.sh` (two-step clone + serve)
- [ ] Host registered under `hosts/<slug>/` with dual-write (portable paths)
- [ ] LLM GPU classified yes (live Metal probe)

## host.toml

Use `host.toml.example`. Do not commit secrets or private absolute homes on public branches.
