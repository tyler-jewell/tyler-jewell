# Host: Mac Studio (slug: mac-studio) — template

**Secondary** host charter for a Mac Studio under Tyler Jewell.  
Umbrella sacred rules remain overall.

## Status

This directory is a **parity template**. It is not proof that a Studio is online.

## Agent scope (when SSH + permission exist)

1. Same stack as MBP: umbrella AGENTS, `~/system` (or Studio home path), Herdr, integrations via live CLI, herdr-web, agent-kit.
2. Full-setup only if live GPU probe reports LLM-capable GPU (Apple Silicon Metal — expected on Studio).
3. Prefer agent-kit over SSH:
   ```bash
   ssh mac-studio 'bash -s' < ~/github-repos/tyler-jewell/agent-kit/scripts/ai-first-setup.sh -- --dry-run
   ```
4. Privileged floor on Studio still needs human sudo once if Nix missing.
5. Do not invent Studio inventory entries without a real probe or human request.
