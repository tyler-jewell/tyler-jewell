---
name: ai-first-host-setup
description: AI-first host setup after Nix floor — discover GPU hosts, Herdr, herdr-web, Studio SSH parity
---

# AI-first host setup

## When to use

Setting up or verifying a Tyler Jewell machine (MBP, Studio, GPU Linux) after the privileged Nix floor, or onboarding a remote host over SSH.

## Layering (do not invert)

1. **Privileged (human):** `sudo ~/system/scripts/privileged-setup.sh` — CLT + Nix only.
2. **Nix/HM:** `home-manager switch --flake ~/system#…`
3. **This skill / agent-kit:** Herdr, integrations (live CLI), herdr-web, hosts registry, remote apply.

## Procedure

1. **Ask for approval** with `ask_user_question` before any `--apply`, remote SSH mutation, or mass `herdr integration install`.
2. Run discovery (dry-run):
   ```bash
   ~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh --dry-run
   ```
3. Confirm **≥1 LLM-capable GPU** for full-setup targets (`llm_gpu=yes` from live probe).
4. For Studio/remote: verify `ssh <alias>` works; follow `~/github-repos/tyler-jewell/hosts/mac-studio/README.md`.
5. Apply only after yes:
   ```bash
   ~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh --apply --yes --propose-host
   ```
6. Never hardcode Herdr integration target lists — use live `herdr integration status` / `--help`.

## Sacred

Umbrella `tyler-jewell/AGENTS.md` rule 9 (live discovery) and dual-write law.
