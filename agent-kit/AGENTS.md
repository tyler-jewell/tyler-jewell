# agent-kit — AI-first host setup (Herdr-first)

Grok and other agents use this kit **after** the privileged Nix floor exists.

## Layering

1. **Human / privileged:** `sudo ~/system/scripts/privileged-setup.sh` (CLT + Nix only).
2. **Nix/HM:** packages via home-manager (`~/system`).
3. **This kit:** live host/GPU discovery, pure `herdr` primitives, herdr-web verify, **Mesh-LLM** availability (primary local/mesh OpenAI-compatible LLM layer), hosts registry proposals. Multi-host / privileged mutation requires **approval** (`ask_user_question` in interactive Grok, or explicit `--apply --yes` — never invent consent).

## Sacred constraints

- Umbrella `../AGENTS.md` (esp. dual-write, no secrets, **live CLI discovery — no hard-coded tool enums**).
- No curl installers for Grok/Herdr here; Mesh-LLM install is **upstream only** (`mesh-llm` CLI / documented install — do not reimplement the mesh).
- No frozen Herdr integration target lists — use `herdr integration status` / `--help`.
- No frozen model/peer catalogs for Mesh — use live `/v1/models` and CLI help.
- Full-setup **serve** targets require **≥1 LLM-capable GPU** (live classify); GPU-less hosts are mesh **clients** via `OPENAI_BASE_URL`.

## Entry

```bash
./scripts/ai-first-setup.sh --dry-run          # default: discover + verify, no mutate
./scripts/ai-first-setup.sh --apply --yes      # after approval
./scripts/discover-hosts.sh                    # local + network candidates
./test/run-tests.sh                            # GPU gate + parsers
```
