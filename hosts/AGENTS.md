# Hosts registry (under Tyler Jewell umbrella)

Agents editing this tree maintain the **inventory of long-lived machines** under Tyler Jewell.

## Rules

1. Umbrella `../AGENTS.md` is sacred and overall — do not contradict it.
2. One directory per host: `hosts/<slug>/` with dual-write `AGENTS.md` + `README.md` and portable `host.toml` / `host.toml.example`.
3. Slug is lowercase hyphenated (e.g. `macbook-pro`). Hostname in machine-local binding comes from live `hostname`.
4. Do not store secrets, SSH private keys, API tokens, or private absolute home paths in public files.
5. Prefer `$HOME`, `~`, and relative repo paths in docs.
6. Adding a host: copy `macbook-pro/` or `mac-studio/` as a template; or agent-kit `--propose-host` after approval.

## Chain position

Umbrella → **hosts / host** → project trees under that host (or separate product repos that still pipe the umbrella).
