# LSP (Language Server Protocol) expectations

Canon for agents: umbrella **AGENTS.md rule 13**.

## What “proper LSP setup” means

| Requirement | Detail |
|-------------|--------|
| Public server | A publicly documented Language Server exists for the language |
| Project attach | Repo has config or clear AGENTS declaration so editors/agents can run that server (e.g. `jsconfig.json`, `go.mod` + gopls, documented `bash-language-server` / `nil`) |
| Agent use | When LSP tools are available in the session, agents **must** use them while coding |
| No papering over | Do not add suppressions/ignores/overrides to silence diagnostics; fix root cause |
| Strict mode | Prefer strict server settings (e.g. `strict` / gopls staticcheck) over loosened configs |

## Public LSPs used in this stack (examples — not a frozen catalog)

| Language | Public LSP (examples) | Notes |
|----------|------------------------|--------|
| **Go** | [gopls](https://go.dev/gopls/) | **Required** for all backend/scripting (umbrella rule 14). Host flake installs `go` + `gopls` |
| JavaScript | [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) | via `jsconfig.json` / `checkJs` (vanilla frontend, rule 15) |
| Shell (Bash) | [bash-language-server](https://github.com/bash-lsp/bash-language-server) | standalone |
| HTML | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (`vscode-html-language-server`) | **npm package only — does not require VS Code IDE** |
| CSS | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (`vscode-css-language-server`) | **npm package only — does not require VS Code IDE** |
| Nix | [nil](https://github.com/oxalica/nil) or [nixd](https://github.com/nix-community/nixd) | standalone |
| TOML | [taplo](https://taplo.tamasfe.dev/) | optional |
| Markdown | optional | pure docs trees may skip |
| **Python** | — | **Forbidden** for agent-authored code (umbrella rule 14). Do not add Pyright trees. |

If a language has no public **standalone** LSP (installable without a proprietary IDE download), **do not adopt it** in an AGENTS-managed tree.

## Inventory of AGENTS trees

| Tree | Languages in active use | Public LSP |
|------|-------------------------|------------|
| `tyler-jewell/` (umbrella, scripts) | Bash; Go when present | bash-language-server; gopls (rule 13 + 14) |
| `tyler-jewell/agent-kit/` | Bash | bash-language-server |
| `tyler-jewell/docs/*`, `hosts/*` | Markdown (docs) | none required for pure docs |
| `herdr-web/` | Go, JavaScript, Bash, HTML, CSS | gopls, typescript-language-server, bash-language-server, vscode-langservers-extracted (html+css; no VS Code app) |
| `$HOME/system/` (machine) | Nix, Bash | nil/nixd, bash-language-server; packages: `go`, `gopls`, Vercel CLI |

Update this table when a tree adds or drops a language (live declaration).
