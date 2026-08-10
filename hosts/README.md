# Hosts

Registry of machines under the Tyler Jewell umbrella. **Public methodology only** — no private absolute home paths in docs.

| Slug | Class | Role |
|------|-------|------|
| [macbook-pro](macbook-pro/) | Primary macOS laptop | Day-0 admin + Nix + agent-kit |
| [mac-studio](mac-studio/) | Mac Studio (template) | Same stack via SSH + agent-kit |

## Full-setup gate

A host is a **full-setup** target only if live discovery reports **≥1 LLM-capable GPU** (`agent-kit` GPU classify). Empty network scans are honest — do not invent machines.

## Add a host

1. Prefer: `agent-kit/scripts/ai-first-setup.sh --apply --yes --propose-host` on the machine  
2. Or copy `macbook-pro/` / `mac-studio/` → `hosts/<new-slug>/`  
3. Dual-write `AGENTS.md` + `README.md`; keep paths as `$HOME` / `~` / relative  
4. Commit in this repo (never secrets, never private absolute homes in public branches)


