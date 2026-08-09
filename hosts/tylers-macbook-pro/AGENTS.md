# Host: Tylers-MacBook-Pro (slug: tylers-macbook-pro)

**Secondary** charter: this physical MacBook Pro.  
Umbrella (`../../AGENTS.md`) remains **overall / sacred**.

## Machine facts

| Fact | Value |
|------|--------|
| Hostname | `Tylers-MacBook-Pro` |
| OS user | `mbp` |
| OS | macOS (Darwin) |
| Home | `/Users/mbp` |
| Role | Primary laptop; day-0 admin + Nix/home-manager |

## Agent scope on this host

1. Honor umbrella sacred rules first.
2. Home admin for this machine lives at `/Users/mbp` with charter `~/AGENTS.md` (machine home git — separate from this umbrella repo).
3. Declarative user env: `~/system` (Nix + home-manager). Day-0 root: `sudo ~/system/scripts/privileged-setup.sh`.
4. GitHub-oriented clones: `~/github-repos/`.
5. Product work: prefer `~/src/<project>/` or clones under `~/github-repos/`.
6. Do not treat this host file as a place for app-specific coding standards.

## Hierarchy

Umbrella → **this host** → deeper trees under `projects/` (or other nested work with their own AGENTS).
