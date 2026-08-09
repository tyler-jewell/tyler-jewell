# Hosts registry (under Tyler Jewell umbrella)

Agents editing this tree maintain the **inventory of long-lived machines** under Tyler Jewell.

## Rules

1. Umbrella `../AGENTS.md` is sacred and overall — do not contradict it.
2. One directory per host: `hosts/<slug>/` with dual-write `AGENTS.md` + `README.md` and a `host.toml` of stable facts.
3. Slug is lowercase hyphenated (e.g. `tylers-macbook-pro`). Hostname in `host.toml` is the real OS hostname.
4. Do not store secrets, SSH private keys, or API tokens here.
5. Adding a host is a small, reviewable change — copy `tylers-macbook-pro/` as a template.

## Chain position

Umbrella → **hosts / host** → project trees under that host (or separate product repos that still pipe the umbrella).
