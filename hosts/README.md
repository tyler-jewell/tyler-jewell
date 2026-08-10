# Hosts

Registry of machines under the Tyler Jewell umbrella.

| Slug | Hostname | User | Role |
|------|----------|------|------|
| [tylers-macbook-pro](tylers-macbook-pro/) | Tylers-MacBook-Pro | `mbp` | Primary macOS laptop admin |
| [mac-studio](mac-studio/) | *(template)* | — | Studio parity via SSH + agent-kit |

## Full-setup gate

A host is a **full-setup** target only if live discovery reports **≥1 LLM-capable GPU** (`agent-kit` GPU classify). Empty network scans are honest — do not invent machines.

## Add a host

1. Prefer: `agent-kit/scripts/ai-first-setup.sh --apply --yes --propose-host` on the machine
2. Or copy `tylers-macbook-pro/` / `mac-studio/` → `hosts/<new-slug>/`
3. Edit `host.toml`, dual-write `AGENTS.md` + `README.md`
4. Commit in the tyler-jewell repo
