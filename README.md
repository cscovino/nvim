# Neovim Config

Personal Neovim configuration written entirely in Lua. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management and **gruvbox** as the default color scheme.

## Structure

```
init.lua                          # Entry point (settings → mappings → lazy → colorscheme)
lua/
├── settings/                     # Core options (indent, search, folds, undodir)
├── mappings/                     # Keymaps (leader: Space, localleader: \)
├── plugin-manager/lazy/          # lazy.nvim bootstrap + plugin specs
├── lsp/
│   ├── language-servers.lua      # lspconfig for all servers
│   └── nvim-cmp.lua              # Completion (nvim-cmp + LuaSnip + lspkind)
└── config/<plugin>/init.lua      # Per-plugin configuration (incl. color-scheme/)
```

## Plugins

### UI

| Plugin | Purpose |
|--------|---------|
| gruvbox | Color scheme (+ nightfox, tokyonight, catppuccin available) |
| lualine | Status line |
| barbar | Buffer tabs |
| nvim-tree | File explorer (floating window) |
| noice + nvim-notify | Enhanced UI for messages, cmdline, and popups |
| nvim-transparent | Transparent background |
| indent-blankline | Indent guides |
| nvim-colorizer | Inline color preview |
| twilight | Dim inactive code |

### Editor

| Plugin | Purpose |
|--------|---------|
| treesitter | Syntax highlighting, folding, refactor, autotag |
| telescope | Fuzzy finder (files, grep, buffers, git branches, diagnostics) |
| nvim-surround | Surround text objects |
| nvim-autopairs | Auto pairs |
| flash.nvim | Quick navigation (`s` / `S`) |
| grug-far | Search and replace |
| mini.move | Move lines/selections |
| undotree | Undo history |
| trouble | Diagnostics list |
| which-key | Keymap hints (`<leader>?` to show all) |
| vim-tmux-navigator | Seamless tmux/nvim navigation |
| toggleterm | Floating terminal |
| vim-be-good | Practice game |

### Git

| Plugin | Purpose |
|--------|---------|
| vim-fugitive | Git commands |
| git-blame | Inline git blame |
| gitsigns | Git signs in gutter |
| diffview | Side-by-side diff and file history |

### LSP & Completion

| Plugin | Purpose |
|--------|---------|
| nvim-lspconfig | LSP client configuration |
| nvim-cmp | Autocompletion engine |
| LuaSnip | Snippet engine |
| lspkind | VS Code-like pictograms |
| lazydev | Lua LSP enhancements |
| conform | Formatting |
| nvim-lint | Linting |

### AI & Tools

| Plugin | Purpose |
|--------|---------|
| copilot.vim | GitHub Copilot (accept: `<S-Tab><S-Tab>`) |
| CopilotChat | AI chat (model: claude-opus-4.5) |
| mcphub | MCP server integration |
| rest.nvim | HTTP client |
| neotest | Test runner (Jest, Vitest) |
| render-markdown | Markdown rendering in buffer |
| pomo | Pomodoro timer |

## LSP Servers

Active: cssls, dockerls, eslint, glsl_analyzer, html, jsonls, lua_ls, pyright, vtsls

Inactive (commented out): astro, golangci_lint_ls, gopls

## Formatters (conform.nvim)

| Tool | Languages |
|------|-----------|
| stylua | Lua |
| prettierd | JS/TS/JSX/TSX/CSS/SCSS/HTML/JSON/YAML/Markdown |

## Linters (nvim-lint)

| Tool | Languages |
|------|-----------|
| eslint (via LSP) | JS/TS |
| glslc | GLSL |
| yamllint | YAML |

## Key Mappings

Leader key is `<Space>`.

### General

| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>W` | Save & quit |
| `<leader>q` | Quit |
| `<leader>Q` | Force quit |
| `<leader>cl` | Clear search highlight |
| `<leader>tt` | Toggle floating terminal |
| `<leader>ca` | Code action |
| `<leader>ut` | Undo tree |
| `<leader>rd` | Reload file (discard changes) |
| `<leader>rf` | Refresh file |
| `<leader>rp` | Search and replace (grug-far) |
| `<leader>tw` | Toggle Twilight |
| `s` / `S` | Flash jump / treesitter |

### Navigation & Buffers

| Key | Action |
|-----|--------|
| `<leader>,` / `<leader>.` | Previous / next buffer |
| `<leader>!` - `<leader>)` | Go to buffer 1-9 / last |
| `<C-p>` | Pick buffer |
| `<leader><` / `<leader>>` | Move buffer left / right |
| `<leader>bp` | Pin buffer |
| `<leader>bc` | Close buffer |
| `<leader>abc` | Close all but current/pinned |

### Telescope

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>cs` | Color schemes |
| `<leader>ch` | Command history |
| `<leader>dd` | Diagnostics |
| `<leader>gr` | LSP references |
| `<leader>ds` | Document symbols |
| `<leader>gc` | Git branches |
| `<leader>fn` | Notification history (noice) |
| `cc` | Conventional commit (type + gitmoji + scope + message) |

### Git (Fugitive)

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gm` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gdf` | Git diff split |
| `<leader>gS` / `<leader>gP` | Stash / stash pop |
| `<leader>dv` | Diffview open |
| `<leader>dh` | Diffview file history |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `<leader>D` | Type definition |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format buffer |
| `<leader>e` | Diagnostic float |
| `<leader>pd` / `<leader>nd` | Previous / next diagnostic |
| `<leader>lc` | Diagnostic loclist |

### AI

| Key | Action |
|-----|--------|
| `<leader>cp` | Open CopilotChat |
| `<leader>prd` | Generate PR description |
| `<leader>cmsg` | Generate commit message |

### Diagnostics (Trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics |
| `<leader>xd` | Buffer diagnostics |
| `<leader>xl` | Location list |
| `<leader>xq` | Quickfix list |

### Sessions (persistence)

| Key | Action |
|-----|--------|
| `<leader>ss` | Restore session |
| `<leader>sd` | Stop session auto-save |

### Testing (neotest)

| Key | Action |
|-----|--------|
| `<leader>rt` | Run nearest test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Toggle test output |

## Setup

```bash
# Clone into Neovim config directory
git clone https://github.com/<user>/nvim-config ~/.config/nvim

# Open Neovim — lazy.nvim will auto-install plugins
nvim
```

### Requirements

- Neovim >= 0.9
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- ripgrep (for Telescope live grep)
- Node.js (for prettierd, ESLint, LSP servers)
- stylua (for Lua formatting)
