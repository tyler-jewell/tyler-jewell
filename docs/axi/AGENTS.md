# docs/axi — AXI alignment audit

Agents maintaining this tree keep the **AXI scorecard** honest and current.

## Rules

1. Sacred umbrella rule **11** (https://axi.md) applies to every agent-invokable surface we ship.
2. Score **only** agent-facing CLIs/skills/MCP/tools — not every markdown paragraph or pure library helper (mark pure libs as N/A where appropriate).
3. Claim **10/10** only for surfaces we own and have remediated; third-party binaries get honest “prefer AXI wrapper” rows.
4. Dual-write: update `README.md` when the scorecard layout changes.
5. After changing agent-kit entrypoints, re-run `agent-kit/scripts/agent-status.sh` and unit tests; refresh scores if principles regress.
