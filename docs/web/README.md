# Web apps — stack bar (rules 15–17)

Canon: umbrella **AGENTS.md** rules **15**, **16**, **17**.  
**Maturity scores (honest):** [../requirements/scorecard.md](../requirements/scorecard.md) — re-score on any related change (rule 18). Public gate stays **BLOCKED** until all sacred requirements are 100%.

## Frontend

- **Vanilla HTML, CSS, JavaScript** only (no React/Vue/Svelte/Angular product surface).
- **Only UI package:** [shadcn](https://ui.shadcn.com/) when a component kit is needed. No MUI, Bootstrap, Chakra, Ant, etc.
- Prefer zero UI package + hand CSS when possible (e.g. herdr-web today).

## PWA — single source of truth

| Item | URL |
|------|-----|
| **SSoT / curriculum** | https://web.dev/learn/pwa |
| **Score** | Lighthouse PWA audits against that checklist |

Before any public web release, score the app against web.dev learn/pwa + Lighthouse. Ship installable, offline-capable, standards-aligned PWAs.

## Auth

- **WebAuthn passkeys** for all user authentication on web apps and their backends (rule 16).
- Password-primary login is out of scope for new work.

## Public hosting

- **Vercel** for public-facing web apps, DBs, MCPs, and similar surfaces (rule 17).
- Host flake installs the **Vercel CLI** (`~/system/modules/home/vercel-cli.nix`).
- Human once: `vercel login` (like `gh auth login`).

## Backend language

- **Go only** (rule 14) — including bridges and API services. **gopls** required (rule 13).
