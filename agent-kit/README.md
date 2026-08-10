# AI-first agent kit

Orchestrates **agent-owned** setup after the Nix/privileged floor:

1. Discover local machine facts (live)
2. Scan network/SSH candidates; accept full-setup only if **LLM-capable GPU**
3. Propose/update tyler-jewell `hosts/` entries
4. Run pure `herdr` health + integration status
5. Verify herdr-web Integrations path
6. Document Studio (or any remote Mac) parity via SSH

## Commands

```bash
# Safe default — no mutations, no fake consent
~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh --dry-run

# After human approval (Grok: ask_user_question; CLI: --yes)
~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh --apply --yes

# Discovery only
~/github-repos/tyler-jewell/agent-kit/scripts/discover-hosts.sh
~/github-repos/tyler-jewell/agent-kit/scripts/discover-hosts.sh --json
```

## Approval gates

| Action | Gate |
|--------|------|
| Dry-run discover/verify | None |
| Write host proposal files | `--apply` (or interactive yes) |
| `herdr integration install` mass ops | `--apply --yes` + explicit targets from live status |
| Remote SSH apply | Human-approved host + working SSH; see `hosts/mac-studio/` |
| Privileged sudo | Never automated — print `privileged-setup` only |

Interactive Grok sessions should use **`ask_user_question`** before `--apply` on remote or multi-host work.

## Layout

```
agent-kit/
  scripts/
    ai-first-setup.sh      # entry
    discover-hosts.sh      # local + network
    lib/
      host-facts.sh        # pure-ish collectors
      gpu-classify.sh      # LLM-GPU accept/reject
      herdr-ops.sh         # pure herdr argv runners
  test/run-tests.sh
  skills/ai-first-host-setup/SKILL.md
```

## Studio parity

See `../hosts/mac-studio/`. Same kit over SSH when permission + keys exist.
