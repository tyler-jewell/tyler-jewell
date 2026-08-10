# Local ports — `ports.toml` (rule 22)

## Why

Many local web apps can run on one machine. Hardcoding `8765` (or any port) in README/AGENTS/code collides and lies. **Claim ports in version control.**

## File location

Every directory with `AGENTS.md` has a sibling:

```text
<path>/AGENTS.md
<path>/ports.toml
```

## Schema

```toml
# Optional metadata
# tree = "my-app"

[[port]]
app = "example-app"           # short id
port = 8765                 # claimed TCP port
host = "127.0.0.1"          # bind/advertise host
purpose = "Integrations UI + bridge"
env_port = "HERDR_WEB_PORT" # env var that may override at runtime
env_host = "HERDR_WEB_HOST"
```

No local web apps:

```toml
# No local web port claims in this tree.
```

## Agent rules

1. **Update `ports.toml` before** wiring a new listener.  
2. **Do not** put sticky `http://127.0.0.1:NNNN/` in docs as the only instruction.  
3. Serve entrypoints **print the live URL** after bind.  
4. Prefer reading claim → env default → bind.  
5. Dual-write AGENTS/README when port claims change.

## Bad vs good

| Bad | Good |
|-----|------|
| `Open http://127.0.0.1:8765/ for the UI` | Claim in `ports.toml`; `serve` prints `url: …`; docs point at ports.toml + status |
| Magic `PORT=8765` in three files | One claim; loaders import it |

## Related

- Sacred rule 19 (DRY) — port number is one fact  
- Sacred rule 9 — don’t hardcode *other products’* inventories; our claims are our SSoT  
