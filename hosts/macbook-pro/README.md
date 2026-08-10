# macbook-pro

Public template for a **primary MacBook Pro** host under Tyler Jewell.

| | Portable form |
|--|--|
| Slug | `macbook-pro` |
| User | `$USER` |
| Home | `$HOME` |
| Admin docs | `$HOME/AGENTS.md` |
| Nix system | `$HOME/system` |
| herdr-web | clone of `github.com/tyler-jewell/herdr-web` (any path) |

Fill `host.toml` from **live** discovery on the machine (see `host.toml.example`).  
Do not put secrets or private absolute home paths in public commits.

Hierarchy probe (automated chain tests only): `projects/_hierarchy-probe/`.
