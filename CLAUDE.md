# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration written entirely in Lua. Plugin management uses [lazy.nvim](https://github.com/folke/lazy.nvim). The active color scheme is **gruvbox**.

## Architecture

Entry point is `init.lua`, which requires modules in a specific order:

1. **`lua/settings/`** - Core Neovim options (indentation, search, folds, undodir)
2. **`lua/mappings/`** - All keymaps; leader is `<Space>`, localleader is `\`
3. **`lua/plugin-manager/lazy/`** - lazy.nvim bootstrap. Plugin specs are split into `lua/plugins/<category>.lua` files (`ai`, `ui`, `editor`, `git`, `lsp`, `tools`) and auto-imported via `{ import = 'plugins' }`.
4. **`lua/config/color-scheme/persist.lua`** - Reads/writes the chosen colorscheme to `~/.local/state/nvim/colorscheme`; falls back to gruvbox. Loaded after plugins.
5. **`lua/lsp/language-servers.lua`** - 0.12 native API: `vim.lsp.config('*', ...)` defaults, per-server overrides, single `vim.lsp.enable({...})`, `LspAttach` autocmd for keymaps + document highlight.
6. **`lua/config/<plugin>/`** - Per-plugin configuration, each in its own directory with `init.lua`. Includes `config/blink/init.lua` (completion engine: blink.cmp + built-in `vim.snippet` + lazydev + blink-cmp-copilot sources).

## Key Conventions

- **Lua formatting**: stylua with 2-space indent, single quotes (`stylua.toml` at root)
- **All config is Lua** - no vimscript files
- **Indentation**: 2 spaces (`shiftwidth=2`, `tabstop=2`, `expandtab`)
- **Plugin config location rule**: small configs (`opts = {}`, simple `init`/`config` < ~5 lines) stay **inline** in the plugin spec under `lua/plugins/<category>.lua`. Non-trivial configs (autocmds, custom keymaps inside `config`, large `opts` tables, setup logic) live in `lua/config/<plugin>/init.lua` and are wired via `config = function() require('config.X') end`.
- **Treesitter** is on the **`main` branch** (new async parser API, required for Neovim 0.12). Configured via `require('nvim-treesitter').install({...})` + a `FileType` autocmd that calls `vim.treesitter.start` and sets `indentexpr`.
- **Treesitter folding** is enabled (`foldmethod=expr` with `nvim_treesitter#foldexpr()`)
- **Copilot** (`zbirenbaum/copilot.lua`): ghost text disabled, suggestions appear in the blink.cmp completion menu via `blink-cmp-copilot`. Accept with `<CR>` like any other completion.
- **Snacks.nvim** modules enabled: `picker`, `explorer`, `notifier`, `terminal`, `image`, `gh`, `git`, `lazygit`. `vim.ui.select` is overridden to use `Snacks.picker.select`.

## LSP Servers

Configured in `lua/lsp/language-servers.lua`: cssls, dockerls, eslint, glsl_analyzer, html, jsonls, lua_ls, pyright, vtsls.

Commented out (inactive): astro, golangci_lint_ls, gopls.

## Formatting (conform.nvim)

Configured in `lua/config/conform/init.lua` with **format-on-save** enabled:

- stylua (Lua)
- prettierd (JS/TS/JSX/TSX/CSS/SCSS/HTML/JSON/YAML/Markdown)

Commented out (inactive): astro (prettierd), Go (goimports_reviser + golines).

## Linting (nvim-lint)

Configured in `lua/config/lint/init.lua`, runs on BufWritePost/BufReadPost:

- yamllint (YAML)
- glslc (GLSL)

Commented out (inactive): golangcilint (Go).

JS/TS linting is handled by the eslint LSP server.

## Testing (neotest)

Configured in `lua/config/neotest/init.lua` with two adapters (order = priority):

1. **neotest-vitest** — auto-detects vitest projects
2. **neotest-jest** — runs `npx jest`, auto-detects `jest.config.*`

Custom consumer auto-opens the output panel after test runs. Keymaps: `<leader>ts` (summary), `<leader>to` (output panel), `<leader>rt` (run nearest test).

## Notable Custom Behavior

- **Conventional commits with gitmoji**: `cc` in normal mode opens a Snacks.picker flow (commit type -> gitmoji -> scope -> message) defined in `lua/config/commits/init.lua`. Pure `vim.ui.select` + `vim.ui.input` chain; runs `git commit` via `vim.fn.system`.
- **CodeCompanion** (`olimorris/codecompanion.nvim`): configured with the Copilot adapter (model: `claude-opus-4.6`), MCP hub integration, and prompt-library slash commands for PR descriptions (`<leader>apd` → `/prd`) and commit messages (`<leader>amg` → `/cmg`). Chat opens as a vertical split (`<leader>ac`); inline edit on visual selection (`<leader>ai`); actions palette (`<leader>aa`). Inside the chat buffer press `ga` to change the adapter and/or model (one picker handles both), `gs` to toggle the system prompt, `gd` for debug info (shows the current adapter/model), and `?` to list all chat keymaps.
- **CodeCompanion CLI** (`:CodeCompanionCLI`): ACP-based bridge to external CLI agents, configured under `interactions.cli.agents` in `lua/config/codecompanion/init.lua`. Two agents are wired up: `claude_code` (runs `claude`, default) and `opencode` (runs `opencode`). Toggle with `<leader>at` — picks the agent via `vim.ui.select`, then toggles the CLI terminal buffer. Override per-command with `:CodeCompanionCLI agent=<name> <prompt>`, open the prompt input with `:CodeCompanionCLI Ask`.
- **Snacks.explorer** (picker-based file tree) with `<leader>nt`
- **Barbar** buffer tabs with `<leader>,`/`.` for prev/next, `<leader>!`-`)` for direct goto, `<leader>bn` to rename a buffer tab
- **Grug-far** for search and replace (`<leader>rp`)
- **Flash.nvim** for quick navigation (`s` / `S`)
- **Terminal toggle** with `<leader>tt` — opens a floating Snacks terminal
- **Trouble** for diagnostics list (`<leader>xx`)

## Commands

```bash
# Format Lua files
stylua lua/

# Check Neovim config for errors
nvim --headless -c 'quit'

# Update plugins (inside Neovim)
:Lazy update

# Sync plugins (inside Neovim)
:Lazy sync
```
