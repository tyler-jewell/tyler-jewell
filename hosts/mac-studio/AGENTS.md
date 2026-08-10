# Host: Mac Studio (slug: `mac-studio`) — template

**Secondary** host charter for a Mac Studio under Tyler Jewell.  
Umbrella sacred rules remain overall.

## Status

This directory is a **parity template**. It is not proof that a Studio is online.

## Portable conventions

| Fact | Convention |
|------|------------|
| Slug | `mac-studio` |
| User | `$USER` on the Studio |
| Home | `$HOME` on the Studio |
| SSH | alias of your choice (e.g. `studio`) after `ssh-copy-id` |

## Agent scope (when SSH + permission exist)

1. Same stack as MacBook Pro: umbrella AGENTS, `$HOME/system`, Herdr, integrations via live CLI, **herdr-web** (public clone), agent-kit, **Mesh-LLM** as primary OpenAI-compatible mesh (`OPENAI_BASE_URL`, default port 9337).
2. Full-setup **serve** only if live GPU probe reports LLM-capable GPU (Apple Silicon Metal — expected on Studio); otherwise join/consume as mesh client.
3. Prefer agent-kit over SSH after the tree is seeded on the Studio.
4. Privileged floor on Studio still needs human sudo once if Nix missing.
5. Do not invent Studio inventory entries without a real probe or human request.
6. Discover models live (`GET …/v1/models`) — never hardcode model inventories.
