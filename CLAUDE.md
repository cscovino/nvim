# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration written entirely in Lua. Plugin management uses [lazy.nvim](https://github.com/folke/lazy.nvim). The active color scheme is **gruvbox**.

## Architecture

Entry point is `init.lua`, which requires modules in a specific order:

1. **`lua/settings/`** - Core Neovim options (indentation, search, folds, undodir)
2. **`lua/mappings/`** - All keymaps; leader is `<Space>`, localleader is `\`
3. **`lua/plugin-manager/lazy/`** - lazy.nvim bootstrap and full plugin spec
4. **`lua/lsp/`** - LSP configuration split into three files:
   - `language-servers.lua` - lspconfig setup for all servers, `on_attach` keymaps, diagnostic config
   - `nvim-cmp.lua` - Completion engine (nvim-cmp + LuaSnip + lspkind)
   - `null-ls.lua` - Formatting (stylua, prettierd, goimports, golines) and diagnostics via none-ls; **format-on-save** is enabled
5. **`lua/config/<plugin>/`** - Per-plugin configuration, each in its own directory with `init.lua`

## Key Conventions

- **Lua formatting**: stylua with 2-space indent, single quotes (`stylua.toml` at root)
- **All config is Lua** - no vimscript files
- **Indentation**: 2 spaces (`shiftwidth=2`, `tabstop=2`, `expandtab`)
- **Treesitter folding** is enabled (`foldmethod=expr` with `nvim_treesitter#foldexpr()`)
- **Copilot accept** is remapped to `<S-Tab><S-Tab>` (tab is used by nvim-cmp)

## LSP Servers

Configured in `lua/lsp/language-servers.lua`: astro, cssls, dockerls, glsl_analyzer, golangci_lint_ls, gopls, html, jsonls, lua_ls, pyright, ts_ls.

## Formatters/Linters (null-ls)

stylua (Lua), prettierd (JS/TS/CSS/HTML), goimports_reviser + golines (Go), golangci_lint (Go), glslc (GLSL), yamllint (YAML).

## Notable Custom Behavior

- **Conventional commits with gitmoji**: `cc` in normal mode opens a Telescope picker flow (commit type -> gitmoji -> scope -> message) defined in `lua/config/telescope/init.lua`
- **CopilotChat**: configured with claude-opus-4.5 model, MCP hub integration, custom prompts for PR descriptions (`<leader>prd`) and commit messages (`<leader>cmsg`)
- **NvimTree** opens automatically on VimEnter as a floating window
- **Barbar** buffer tabs with `<leader>,`/`.` for prev/next, `<leader>!`-`)` for direct goto

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
