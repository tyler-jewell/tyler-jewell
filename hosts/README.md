# Hosts

Registry of machines under the Tyler Jewell umbrella.

| Slug | Hostname | User | Role |
|------|----------|------|------|
| [tylers-macbook-pro](tylers-macbook-pro/) | Tylers-MacBook-Pro | `mbp` | Primary macOS laptop admin |

## Add a host

1. Copy `tylers-macbook-pro/` → `hosts/<new-slug>/`
2. Edit `host.toml`, `AGENTS.md`, `README.md`
3. Commit in the tyler-jewell repo
4. On the machine: clone this repo; keep local admin under that host’s documented paths (e.g. `$HOME` + `~/system` on the MBP)
