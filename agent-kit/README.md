# AI-first agent kit

Orchestrates **agent-owned** setup after the Nix/privileged floor.

**Human first (manual):** if GitHub remotes, publish, or `gh` inventory are in scope, run **`gh auth login` before** starting this kit or the rest of day-0. Agents cannot complete GitHub OAuth.

1. Discover local machine facts (live)
2. Scan network/SSH candidates; accept full-setup only if **LLM-capable GPU**
3. Report **Mesh-LLM** status (primary local/mesh OpenAI-compatible layer at `…/v1`, default port `9337`)
4. Propose/update tyler-jewell `hosts/` entries
5. Run pure `herdr` health + integration status
6. Verify herdr-web Integrations path
7. Document Studio (or any remote Mac) parity via SSH

### Mesh-LLM (main LLM availability)

| Role | When | Action |
|------|------|--------|
| **server** | `mesh-llm` + LLM GPU + `/v1` up on this host | Prefer `OPENAI_BASE_URL=http://127.0.0.1:9337/v1` |
| **server-capable** | `mesh-llm` + LLM GPU, endpoint not up yet | `mesh-llm setup` then `mesh-llm serve --auto` (upstream) |
| **client-peer** | `/v1` up but this host cannot serve (no bin and/or no GPU) | Point tools at mesh base URL — do **not** treat as local serve |
| **client-only** | binary, no GPU, no endpoint | `mesh-llm client --auto` / set base URL when a peer exists |
| **unavailable** | no binary, no endpoint | Install via [upstream](https://github.com/Mesh-LLM/mesh-llm); client contract still documented |

`mesh_llm_can_serve` is **binary ∧ LLM GPU** only — a remote peer’s open `/v1` never implies this host can serve.

Never hardcode model ids — list them live: `curl -s "$OPENAI_BASE_URL/models"`.

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
