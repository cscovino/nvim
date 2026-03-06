# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration written entirely in Lua. Plugin management uses [lazy.nvim](https://github.com/folke/lazy.nvim). The active color scheme is **gruvbox**.

## Architecture

Entry point is `init.lua`, which requires modules in a specific order:

1. **`lua/settings/`** - Core Neovim options (indentation, search, folds, undodir)
2. **`lua/mappings/`** - All keymaps; leader is `<Space>`, localleader is `\`
3. **`lua/plugin-manager/lazy/`** - lazy.nvim bootstrap and full plugin spec
4. **`lua/config/color-scheme/gruvbox`** - Color scheme setup (loaded after plugins)
5. **`lua/lsp/`** - LSP configuration split into two files:
   - `language-servers.lua` - lspconfig setup for all servers, `on_attach` keymaps, diagnostic config
   - `nvim-cmp.lua` - Completion engine (nvim-cmp + LuaSnip + lspkind)
6. **`lua/config/<plugin>/`** - Per-plugin configuration, each in its own directory with `init.lua`

## Key Conventions

- **Lua formatting**: stylua with 2-space indent, single quotes (`stylua.toml` at root)
- **All config is Lua** - no vimscript files
- **Indentation**: 2 spaces (`shiftwidth=2`, `tabstop=2`, `expandtab`)
- **Treesitter folding** is enabled (`foldmethod=expr` with `nvim_treesitter#foldexpr()`)
- **Copilot accept** is remapped to `<S-Tab><S-Tab>` (tab is used by nvim-cmp)

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

- **Conventional commits with gitmoji**: `cc` in normal mode opens a Telescope picker flow (commit type -> gitmoji -> scope -> message) defined in `lua/config/telescope/init.lua`
- **CopilotChat**: configured with claude-opus-4.5 model, MCP hub integration, custom prompts for PR descriptions (`<leader>prd`) and commit messages (`<leader>cmsg`)
- **NvimTree** as floating window with `<leader>nt`
- **Barbar** buffer tabs with `<leader>,`/`.` for prev/next, `<leader>!`-`)` for direct goto
- **Grug-far** for search and replace (`<leader>rp`)
- **Flash.nvim** for quick navigation (`s` / `S`)
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
