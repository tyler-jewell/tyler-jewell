# mac-studio (template)

Bring a Mac Studio to the same AI-first stack as this MacBook Pro, **after** human permission and working SSH.

## Human prerequisites (exact)

```bash
# 1) On Studio: create user, enable Remote Login (SSH)
# 2) From this Mac — replace alias/user/host as needed:
ssh-copy-id user@mac-studio.local
ssh user@mac-studio.local 'hostname; uname -m'

# 3) If Studio has no Nix yet (human once on Studio terminal):
ssh -t user@mac-studio.local 'sudo bash -s' < ~/system/scripts/privileged-setup.sh
# or install Determinate Nix GUI on Studio, then:

# 4) Seed umbrella + system (example):
# rsync or git clone tyler-jewell + system allowlist onto Studio home

# 5) Agent dry-run on Studio:
ssh user@mac-studio.local '~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh --dry-run'

# 6) After approval:
ssh user@mac-studio.local '~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh --apply --yes --propose-host'
```

## Same-as-MBP checklist

- [ ] Umbrella `tyler-jewell` AGENTS present
- [ ] Nix + home-manager apply
- [ ] `herdr` on PATH; `herdr config check`; integrations via live status
- [ ] herdr-web serve + Integrations UI
- [ ] Host registered under `hosts/<slug>/` with dual-write
- [ ] LLM GPU classified yes (live Metal probe)

## host.toml

Fill when a real Studio is enrolled (see `host.toml.example`). Do not commit secrets.
