# herdr-kit — agent notes

## Scope

Core **Tyler Jewell** Herdr methodology only: flash, dry-run, wipe/bootstrap, AGENTS pipe/chain, evals.

**Not here:** herdr-web, browsers, product UI.

## Rules

1. Mutating scripts default to **dry-run**. Writes need `--apply`. Wipe/nuke need `--apply --yes` and `--level`.
2. Never wipe `/nix`, `~/system`, `~/github-repos/tyler-jewell`, SSH keys.
3. Do not run destructive levels without explicit human approval.
4. Sacred umbrella rules 1–21 apply (especially 19 DRY, 20 simplicity, 21 authority).
5. Dual-write AGENTS/README when actions change.
6. AXI: exit 2 unknown flags; content-first; `--help`.

## Verify

```bash
herdr plugin link .
herdr plugin action invoke tyler-jewell.herdr-kit.status
herdr plugin action invoke tyler-jewell.herdr-kit.flash
./scripts/evals.sh run
```
