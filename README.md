# Neovim Config

Personal Neovim configuration written entirely in Lua. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management and **gruvbox** as the default color scheme.

## Structure

```
init.lua                          # Entry point (settings → mappings → lazy → colorscheme)
lua/
├── settings/                     # Core options (indent, search, folds, undodir)
├── mappings/                     # Keymaps (leader: Space, localleader: \)
├── plugin-manager/lazy/          # lazy.nvim bootstrap (imports lua/plugins/*)
├── plugins/                      # Plugin specs split by category
│   ├── ai.lua                    # copilot.lua, codecompanion, mcphub
│   ├── ui.lua                    # colorschemes, lualine, barbar, snacks, twilight, transparent, indent-blankline, colorizer
│   ├── editor.lua                # treesitter, render-markdown, trouble, mini.*, flash, which-key, persistence, undotree
│   ├── git.lua                   # diffview
│   ├── lsp.lua                   # lspconfig, blink.cmp, lazydev, conform, lint, dap
│   └── tools.lua                 # luarocks, rest, neotest, pomo, vim-be-good
├── lsp/
│   └── language-servers.lua      # vim.lsp.config + LspAttach autocmd
├── utils/                        # Cross-plugin helpers (notifier)
└── config/<plugin>/init.lua      # Per-plugin configuration (incl. color-scheme/persist.lua, blink/init.lua)
```

## Plugins

### UI

| Plugin           | Purpose                                                                                            |
| ---------------- | -------------------------------------------------------------------------------------------------- |
| gruvbox          | Default color scheme (also installed: nightfox, tokyonight, catppuccin — last choice is persisted) |
| snacks.nvim      | Pickers, explorer, notifier, terminal, image, gh, git, lazygit                                     |
| lualine          | Status line                                                                                        |
| barbar           | Buffer tabs                                                                                        |
| nvim-transparent | Transparent background                                                                             |
| indent-blankline | Indent guides                                                                                      |
| nvim-colorizer   | Inline color preview                                                                               |
| twilight         | Dim inactive code                                                                                  |

### Editor

| Plugin             | Purpose                                          |
| ------------------ | ------------------------------------------------ |
| treesitter (main)  | Async parser API, syntax highlight, indent       |
| treesitter-context | Sticky scope header                              |
| nvim-ts-autotag    | HTML/JSX auto-close tags                         |
| mini.surround      | Surround text objects (`ys` / `ds` / `cs`)       |
| mini.pairs         | Auto pairs                                       |
| mini.ai            | Smarter text objects (`vif`, `va,`, `va)`, etc.) |
| mini.move          | Move lines / selections                          |
| flash.nvim         | Quick navigation (`s` / `S`)                     |
| grug-far           | Search and replace                               |
| undotree           | Undo history                                     |
| trouble            | Diagnostics list                                 |
| which-key          | Keymap hints (`<leader>?` to show all)           |
| vim-tmux-navigator | Seamless tmux/nvim navigation                    |
| vim-be-good        | Practice game                                    |

### Git

| Plugin              | Purpose                                            |
| ------------------- | -------------------------------------------------- |
| gitsigns            | Git signs in gutter                                |
| diffview            | Side-by-side diff and file history                 |
| Snacks.git          | LSP-style `blame_line()` popup                     |
| Snacks.lazygit      | Lazygit TUI in floating window (requires lazygit)  |
| Snacks.gh           | GitHub issues / PRs picker (requires `gh` CLI)     |
| Snacks.picker (git) | `git_status` / `git_branches` pickers              |

### LSP & Completion

| Plugin            | Purpose                                                   |
| ----------------- | --------------------------------------------------------- |
| nvim-lspconfig    | Server runtime files (`lsp/<server>.lua`) for 0.12 API    |
| blink.cmp         | Autocompletion engine (Rust fuzzy matcher)                |
| blink-cmp-copilot | Copilot suggestions as a blink source                     |
| lazydev           | Lua LSP enhancements for Neovim Lua API                   |
| conform           | Formatting (format-on-save)                               |
| nvim-lint         | Linting on BufReadPost / BufWritePost                     |
| nvim-dap          | Debug Adapter Protocol (+ dap-ui, vscode-js-debug)        |

### AI & Tools

| Plugin              | Purpose                                                                        |
| ------------------- | ------------------------------------------------------------------------------ |
| copilot.lua         | GitHub Copilot (ghost text disabled; suggestions live in the blink.cmp menu)   |
| codecompanion       | AI chat + inline edits + CLI bridge (adapter: Copilot, model: claude-opus-4.6) |
| mcphub              | MCP server integration                                                         |
| rest.nvim           | HTTP client                                                                    |
| neotest             | Test runner (Jest, Vitest)                                                     |
| render-markdown     | Markdown rendering in buffer (skips non-file buffers via `ignore` callback)    |
| pomo                | Pomodoro timer                                                                 |

CodeCompanion also exposes `:CodeCompanionCLI`, an ACP bridge to external CLI agents. Two agents are wired up out of the box: `claude_code` (the `claude` CLI, default) and `opencode` (the `opencode` CLI). Pick per command with `:CodeCompanionCLI agent=<name>`.

## LSP Servers

Active: cssls, dockerls, eslint, glsl_analyzer, html, jsonls, lua_ls, pyright, vtsls

Inactive (commented out): astro, golangci_lint_ls, gopls

Config uses Neovim 0.12's native API: `vim.lsp.config('*', {...})` for shared defaults, `vim.lsp.config(name, ...)` for per-server overrides, single `vim.lsp.enable({...})` call. LSP keymaps + document highlight wired through a single `LspAttach` autocmd.

## Formatters (conform.nvim)

| Tool      | Languages                                      |
| --------- | ---------------------------------------------- |
| stylua    | Lua                                            |
| prettierd | JS/TS/JSX/TSX/CSS/SCSS/HTML/JSON/YAML/Markdown |

## Linters (nvim-lint)

| Tool             | Languages |
| ---------------- | --------- |
| eslint (via LSP) | JS/TS     |
| glslc            | GLSL      |
| yamllint         | YAML      |

## Key Mappings

Leader key is `<Space>`.

### General

| Key          | Action                            |
| ------------ | --------------------------------- |
| `<leader>w`  | Save                              |
| `<leader>W`  | Save & quit                       |
| `<leader>q`  | Quit                              |
| `<leader>Q`  | Force quit                        |
| `<leader>cl` | Clear search highlight            |
| `<leader>tt` | Toggle floating Snacks terminal   |
| `<leader>nt` | Toggle Snacks.explorer file tree  |
| `<leader>ca` | Code action                       |
| `<leader>ut` | Undo tree                         |
| `<leader>rd` | Reload file (discard changes)     |
| `<leader>rf` | Refresh file                      |
| `<leader>rp` | Search and replace (grug-far)     |
| `<leader>tw` | Toggle Twilight                   |
| `s` / `S`    | Flash jump / treesitter           |

### Navigation & Buffers

| Key                       | Action                       |
| ------------------------- | ---------------------------- |
| `<leader>,` / `<leader>.` | Previous / next buffer       |
| `<leader>!` - `<leader>)` | Go to buffer 1-9 / last      |
| `<C-p>`                   | Pick buffer                  |
| `<leader><` / `<leader>>` | Move buffer left / right     |
| `<leader>bp`              | Pin buffer                   |
| `<leader>bc`              | Close buffer                 |
| `<leader>bo`              | Close all but current/pinned |
| `<leader>bn`              | Rename buffer tab            |

### Snacks Pickers

| Key          | Action                                                 |
| ------------ | ------------------------------------------------------ |
| `<leader>ff` | Find files                                             |
| `<leader>fg` | Live grep                                              |
| `<leader>fb` | Buffers                                                |
| `<leader>fh` | Help tags                                              |
| `<leader>cs` | Color schemes (selection persists across sessions)     |
| `<leader>ch` | Command history                                        |
| `<leader>dd` | Diagnostics                                            |
| `<leader>gr` | LSP references                                         |
| `<leader>ds` | Document symbols                                       |
| `<leader>fN` | Notification history (Snacks.notifier)                 |
| `cc`         | Conventional commit (type + gitmoji + scope + message) |

### Git

| Key           | Action                                  |
| ------------- | --------------------------------------- |
| `<leader>gg`  | Lazygit (requires `lazygit` CLI)        |
| `<leader>gs`  | Git status picker (stage with `<Tab>`)  |
| `<leader>gc`  | Git branches picker                     |
| `<leader>gb`  | Git blame line (popup)                  |
| `<leader>gl`  | Git pull (floating terminal)            |
| `<leader>gP`  | Git push (floating terminal)            |
| `<leader>gi`  | GitHub issues (requires `gh` CLI)       |
| `<leader>gp`  | GitHub PRs (requires `gh` CLI)          |
| `<leader>dv`  | Diffview open                           |
| `<leader>dh`  | Diffview file history                   |

### LSP

| Key                         | Action                     |
| --------------------------- | -------------------------- |
| `gd`                        | Go to definition           |
| `<leader>D`                 | Type definition            |
| `<leader>rn`                | Rename symbol              |
| `<leader>f`                 | Format buffer              |
| `<leader>e`                 | Diagnostic float           |
| `<leader>pd` / `<leader>nd` | Previous / next diagnostic |
| `<leader>lc`                | Diagnostic loclist         |

Document highlight (CursorHold) is wired automatically for any LSP that supports `textDocument/documentHighlight`.

### AI

All CodeCompanion mappings live under `<leader>a` (group: "AI").

| Key           | Mode | Action                                                |
| ------------- | ---- | ----------------------------------------------------- |
| `<leader>ac`  | n    | Toggle CodeCompanion chat                             |
| `<leader>aa`  | n    | CodeCompanion actions palette (uses Snacks.picker)    |
| `<leader>ai`  | v    | Inline edit on visual selection                       |
| `<leader>at`  | n    | Toggle CodeCompanion CLI (picks agent via `vim.ui.select`) |
| `<leader>amg` | n    | Generate commit message (slash `/cmg`)                |
| `<leader>apd` | n    | Generate PR description (slash `/prd`)                |

Inside the CodeCompanion chat buffer: `ga` change adapter + model, `gs` toggle system prompt, `gd` debug info (current adapter/model), `?` show all keymaps.

### Diagnostics (Trouble)

| Key          | Action             |
| ------------ | ------------------ |
| `<leader>xx` | Toggle diagnostics |
| `<leader>xd` | Buffer diagnostics |
| `<leader>xl` | Location list      |
| `<leader>xq` | Quickfix list      |

### Debug (nvim-dap)

| Key                         | Action                |
| --------------------------- | --------------------- |
| `<leader>db`                | Toggle breakpoint     |
| `<leader>dB`                | Conditional breakpoint |
| `<leader>dc`                | Continue / Start      |
| `<leader>di` / `<leader>do` | Step into / over      |
| `<leader>dO`                | Step out              |
| `<leader>dr`                | Restart               |
| `<leader>dt`                | Terminate             |
| `<leader>du`                | Toggle DAP UI         |
| `<leader>de`                | Eval expression       |

### Sessions (persistence)

| Key          | Action                 |
| ------------ | ---------------------- |
| `<leader>ss` | Restore session        |
| `<leader>sd` | Stop session auto-save |

### Testing (neotest)

| Key          | Action              |
| ------------ | ------------------- |
| `<leader>rt` | Run nearest test    |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Toggle test output  |

## Setup

```bash
# Clone into Neovim config directory
git clone https://github.com/<user>/nvim-config ~/.config/nvim

# Open Neovim — lazy.nvim will auto-install plugins,
# nvim-treesitter (main branch) will compile parsers on first run
nvim
```

### Requirements

- Neovim **>= 0.12**
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for diagnostic / picker icons
- ripgrep + fd (for Snacks.picker files / live grep)
- Node.js (for prettierd, ESLint, LSP servers)
- stylua (for Lua formatting)

### Optional CLIs (enable extra features)

- `lazygit` — for `<leader>gg` lazygit TUI
- `gh` — for GitHub issue / PR pickers (`<leader>gi`, `<leader>gp`)
- `delta` — alternative diff renderer (set `previewers.diff.style = 'terminal'` in Snacks config)
