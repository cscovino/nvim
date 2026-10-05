# Neovim Config

Personal Neovim configuration written entirely in Lua. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management and **gruvbox** as the default color scheme.

## Structure

```
init.lua                          # Entry point (settings → mappings → lazy → colorscheme)
install.sh                        # One-command installer (see Install)
lua/
├── settings/                     # Core options (indent, search, folds, undodir)
├── mappings/                     # Keymaps (leader: Space, localleader: \)
├── plugin-manager/lazy/          # lazy.nvim bootstrap (imports only the categories the profile enables)
├── profile/
│   ├── init.lua                  # Presets, categories, state file
│   └── menu.lua                  # :Profile
├── plugins/                      # Plugin specs, one file per category
│   ├── ai.lua                    # copilot.lua, codecompanion, mcphub
│   ├── debug.lua                 # nvim-dap, dap-ui, vscode-js-debug
│   ├── editor.lua                # treesitter, ts-autotag, treesitter-context, render-markdown, trouble, grug-far, mini.*, flash, which-key, persistence, vim-tmux-navigator, undotree
│   ├── extras.lua                # pomo, vim-be-good
│   ├── http.lua                  # luarocks, rest
│   ├── lsp.lua                   # lazydev, lspconfig, blink.cmp, blink-cmp-copilot, conform, lint
│   ├── testing.lua               # neotest with jest and vitest
│   └── ui.lua                    # colorschemes, devicons, indent-blankline, colorizer, lualine, transparent, barbar, gitsigns, twilight, snacks
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

Active: clangd, cssls, dockerls, eslint, glsl_analyzer, html, jsonls, lua_ls, pyright, vtsls

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

## Install

One script sets up Neovim, system deps, language tools, this config, the profile and the plugins. It is safe to re-run: a set-up machine changes nothing.

```bash
# Straight from GitHub
curl -fsSL https://raw.githubusercontent.com/cscovino/nvim/main/install.sh | bash
# Same, but keeps the terminal attached so prompts and the menu work
bash <(curl -fsSL https://raw.githubusercontent.com/cscovino/nvim/main/install.sh)
# From a clone
~/.config/nvim/install.sh

# Add --dry-run first to see every command without changing anything
```

Without `--only` (and without `--yes`) a menu asks which part to run: everything, nvim, deps, lsp, config or plugins.

| Flag                                      | Effect                                                                                                   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `-h`                                      | Show usage                                                                                               |
| `--yes`                                   | No prompts; keeps a working Neovim >= 0.12                                                               |
| `--dry-run`                               | Print every command, change nothing                                                                      |
| `--profile full\|minimal`                 | Profile to write; defaults to full on macOS and minimal on Linux; without it an existing profile is kept |
| `--nvim-version stable\|nightly\|vX.Y.Z`  | Install that Neovim; tags >= v0.12.0                                                                     |
| `--only nvim\|deps\|lsp\|config\|plugins` | Run one step; `--only plugins` forces a plugin restore and parser build                                  |

### macOS

Apple Silicon (arm64).

- ripgrep and fd come from Homebrew, only if missing.
- A working Neovim >= 0.12 (Homebrew's, for example) is kept unless you pick a version. Picked versions go to `~/.local/opt` with a `~/.local/bin/nvim` symlink. The script never uninstalls anything: when another `nvim` wins in PATH it warns and prints a removal hint.
- The tree-sitter CLI is the latest GitHub binary in `~/.local/bin`. A broken pnpm `tree-sitter` is left in place, with a `pnpm rm -g tree-sitter-cli` hint if it still wins in PATH.
- node, pyright, clangd and lua-language-server are not installed on macOS; a missing one gets a one-line hint.
- The default profile is full.

### Linux

- Requirements: apt-based, aarch64, glibc >= 2.28. sudo is used only for `apt-get`, after a confirmation unless `--yes`.
- Tested on a Jetson Nano with Ubuntu 20.04.
- apt packages: `build-essential git curl fd-find clangd-18`, plus an `fd` symlink.
- Neovim comes from `neovim/neovim-releases` when glibc < 2.35; nightly only from the official repo.
- Into `~/.local`: Node 24 (`latest-v24.x`) with pyright, `clangd` linked to clangd-18, lua-language-server 3.19.1, ripgrep 15.2.0, and tree-sitter (v0.25.10 when glibc < 2.39).
- The default profile is minimal.
- Add `~/.local/bin` to PATH with the `export` line the script prints. The script never edits shell rc files.

> **Jetson Nano:** use the Ubuntu 20.04 image. Stock JetPack is Ubuntu 18.04 with glibc 2.27, which the script refuses.
> tree-sitter is pinned to v0.25.10, so `:checkhealth nvim-treesitter` shows the ERROR `tree-sitter-cli v0.26.1 is required`. That is expected: parsers still build.
> If Node 24 does not run on the 4.9 kernel, the script stops and names Node 22 (`latest-v22.x`). If parsers do not build, it stops and names `cargo install --locked tree-sitter-cli`.

### Profiles

- Presets: `full` (every category) and `minimal` (ui, editor, lsp).
- ai, debug, testing, http and extras toggle on top of the preset. `:Profile` changes and saves them (restart to apply).
- The profile lives in `~/.local/state/nvim/profile`.
- `NVIM_PROFILE=full nvim` (or `minimal`) overrides it for one run.
- After a plugins-step failure, re-run with `--only plugins`: a plain re-run skips installed plugins.

## Setup

Manual path, without the script:

```bash
# Clone into Neovim config directory
git clone https://github.com/cscovino/nvim.git ~/.config/nvim

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
