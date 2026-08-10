# AXI scorecard — managed agent surfaces

Canon: [https://axi.md](https://axi.md).  
Scoring: each of 10 principles = **met** | **na** | **fail**.  
**10/10** = all *applicable* principles **met** (na excluded from denominator).

Last audited: 2026-08-09 (post skeptic re-score) · Owner surfaces under `tyler-jewell`.

## Legend (principles P1–P10)

| ID | Principle |
|----|-----------|
| P1 | Token-efficient output |
| P2 | Minimal default schemas |
| P3 | Content truncation |
| P4 | Pre-computed aggregates |
| P5 | Definitive empty states |
| P6 | Structured errors & exit codes (non-interactive, unknown flags loud) |
| P7 | Ambient context (hooks/skills) |
| P8 | Content first (no-args → live data) |
| P9 | Contextual disclosure (`help[]`) |
| P10 | Consistent `--help` |

## Inventory & scores

| Surface | Kind | Owner | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | P10 | Score | Notes |
|---------|------|-------|----|----|----|----|----|----|----|----|----|-----|-------|-------|
| `agent-kit/scripts/agent-status.sh` | CLI | **ours** | met | met | met | met | met | met | met | met | met | met | **10/10** | Primary AXI entry; skill points here |
| `agent-kit/scripts/lib/axi-out.sh` | pure lib | **ours** | met | met | met | met | met | met | na | na | met | na | **7/7** | Helpers only; na for CLI framing |
| `agent-kit/scripts/ai-first-setup.sh` | CLI | **ours** | met | met | met | met | met | met | met | met | met | met | **10/10** | Default `--dry-run` content; axi summary; exit 2 unknown |
| `agent-kit/scripts/discover-hosts.sh` | CLI | **ours** | met | met | na | met | met | met | na | met | met | met | **8/8** | P3 na (small output); P7 via skill |
| `scripts/pipe-agents.sh` | CLI | **ours** | met | met | na | na | met | met | na | met | met | met | **7/7** | Emits charter; `--help` + help[] |
| `scripts/hierarchy-order.sh` | CLI | **ours** | met | met | na | met | met | met | na | met | met | met | **8/8** | Outer→inner paths; empty fails loud |
| `agent-kit/skills/ai-first-host-setup/SKILL.md` | skill | **ours** | met | met | na | met | na | met | met | met | met | met | **8/8** | Ambient guidance; points to AXI status |
| `herdr` CLI | upstream | third-party | — | — | — | — | — | — | — | — | — | — | **prefer AXI/wrap** | Do not claim 10/10; use live status via our adapters |
| `mesh-llm` CLI | upstream | third-party | — | — | — | — | — | — | — | — | — | — | **prefer AXI/wrap** | Our mesh helpers + `/v1/models` live |
| `gh` CLI | upstream | third-party | — | — | — | — | — | — | — | — | — | — | **prefer [gh-axi](https://github.com/kunchenguid/gh-axi)** | Sacred: use AXI catalog when available |
| `home-manager` / `nix` | upstream | third-party | — | — | — | — | — | — | — | — | — | — | **prefer wrap** | bootstrap thin glue only |
| `system/scripts/bootstrap.sh` | CLI | **ours** | met | met | na | met | met | met | na | met | met | met | **8/8** | --help fixed (no $(parse_args) capture); exit 2 unknown opts |
| `system/scripts/privileged-setup.sh` | CLI | **ours** | na | na | na | met | met | met | na | na | met | met | **5/5** | --help before root check; human-root only for real work |
| Host `AGENTS.md` templates | docs | **ours** | na | na | na | na | na | na | met | na | met | na | **2/2** | Point at sacred AXI + agent-status |

### Owned agent-facing CLIs claimed 10/10

- `agent-kit/scripts/agent-status.sh` — full AXI framing  
- `agent-kit/scripts/ai-first-setup.sh` — remediated for P1–P10 applicable  

### Gaps closed this audit

- Added sacred rule 11 + scorecard  
- Added `axi-out.sh` + `agent-status.sh`  
- pipe-agents / hierarchy-order / discover-hosts / ai-first-setup: `--help`, exit 2, help[], aggregates, empty states  
- **Skeptic re-score fixes:** `bootstrap.sh --help` (no longer captures usage via `$(parse_args)`); `serve.sh` unknown flags exit 2 + `--help`; `privileged-setup.sh --help` before root check  

### Explicit non-claims

Upstream `herdr`, `mesh-llm`, `gh`, `nix` are **not** 10/10 AXI products in this tree. Agents must prefer catalog AXIs or our thin adapters.
