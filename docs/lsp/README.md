# LSP (Language Server Protocol) expectations

Canon for agents: umbrella **AGENTS.md rule 13**.

## What “proper LSP setup” means

| Requirement | Detail |
|-------------|--------|
| Public server | A publicly documented Language Server exists for the language |
| Project attach | Repo has config or clear AGENTS declaration so editors/agents can run that server (e.g. `jsconfig.json`, `pyrightconfig.json`, documented `bash-language-server` / `nil`) |
| Agent use | When LSP tools are available in the session, agents **must** use them while coding |
| No papering over | Do not add suppressions/ignores/overrides to silence diagnostics; fix root cause |
| Strict mode | Prefer strict server settings (e.g. `strict` / `typeCheckingMode: strict`) over loosened configs |

## Public LSPs used in this stack (examples — not a frozen catalog)

| Language | Public LSP (examples) | Notes |
|----------|------------------------|--------|
| JavaScript | [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) | via `jsconfig.json` / `checkJs` |
| Python | [Pyright](https://github.com/microsoft/pyright) / pylsp | strict typeCheckingMode preferred |
| Shell (Bash) | [bash-language-server](https://github.com/bash-lsp/bash-language-server) | standalone |
| HTML | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (`vscode-html-language-server`) | **npm package only — does not require VS Code IDE** |
| CSS | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (`vscode-css-language-server`) | **npm package only — does not require VS Code IDE** |
| Nix | [nil](https://github.com/oxalica/nil) or [nixd](https://github.com/nix-community/nixd) | standalone |
| TOML | [taplo](https://taplo.tamasfe.dev/) | optional |
| Markdown | optional | pure docs trees may skip |

If a language has no public **standalone** LSP (installable without a proprietary IDE download), **do not adopt it** in an AGENTS-managed tree.

## Inventory of AGENTS trees

| Tree | Languages in active use | Public LSP |
|------|-------------------------|------------|
| `tyler-jewell/` (umbrella, scripts) | Bash | bash-language-server (declared in root AGENTS rule 13) |
| `tyler-jewell/agent-kit/` | Bash | bash-language-server |
| `tyler-jewell/docs/*`, `hosts/*` | Markdown (docs) | none required for pure docs |
| `herdr-web/` | JavaScript, Python, Bash, HTML, CSS | typescript-language-server, Pyright, bash-language-server, vscode-langservers-extracted (html+css; no VS Code app) |
| `$HOME/system/` (machine) | Nix, Bash | nil/nixd, bash-language-server |

Update this table when a tree adds or drops a language (live declaration).
