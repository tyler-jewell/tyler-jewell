# agent-kit — AI-first host setup (Herdr-first)

Grok and other agents use this kit **after** the privileged Nix floor exists.

## Layering

1. **Human / privileged:** `sudo ~/system/scripts/privileged-setup.sh` (CLT + Nix only).
2. **Nix/HM:** packages via home-manager (`~/system`).
3. **This kit:** live host/GPU discovery, pure `herdr` primitives, herdr-web verify, **Mesh-LLM** availability (primary local/mesh OpenAI-compatible LLM layer), hosts registry proposals. Multi-host / privileged mutation requires **approval** (`ask_user_question` in interactive Grok, or explicit `--apply --yes` — never invent consent).
4. **Host runtime policy (human questions):** On host setup / first AI-first apply, **ask the human** (never invent):
   1. Always on and active?
   2. Restart managed services after power outage / reboot / macOS update?
   Write only to **`$HOME/system/host-runtime.toml`** (SSoT), set `confirmed_by = "human"`, then HM switch. See `$HOME/system/AGENTS.md`.

## Sacred constraints

- Umbrella `../AGENTS.md` (esp. dual-write, no secrets, **live CLI discovery**, **AXI rule 11**, **LSP rule 13**).
- Every agent-invokable kit CLI/skill must meet applicable AXI principles (see `docs/axi/axi-scorecard.md`). Prefer **`scripts/agent-status.sh`** as the compact AXI status entry.
- **Languages in use:** Bash. **Public LSP:** bash-language-server. Agents MUST use LSP tools when coding; no suppressions-as-fix; root-cause only (rule 13).
- No curl installers for Grok/Herdr here; Mesh-LLM install is **upstream only** (`mesh-llm` CLI / documented install — do not reimplement the mesh).
- No frozen Herdr integration target lists — use `herdr integration status` / `--help`.
- No frozen model/peer catalogs for Mesh — use live `/v1/models` and CLI help.
- Full-setup **serve** targets require **≥1 LLM-capable GPU** (live classify); GPU-less hosts are mesh **clients** via `OPENAI_BASE_URL`.

## Entry

```bash
./scripts/agent-status.sh                      # AXI content-first live status (prefer for agents)
./scripts/ai-first-setup.sh --dry-run          # default: discover + verify, no mutate
./scripts/ai-first-setup.sh --apply --yes      # after approval
./scripts/discover-hosts.sh                    # local + network candidates
./evals/run.sh run                             # kit compliance evals (≤10)
./test/run-tests.sh                            # GPU gate + parsers + axi-out
```

**UI product:** isolatable **herdr-web** plugin (not this kit). Link: `herdr plugin link $HOME/github-repos/herdr-web`.
