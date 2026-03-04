# Neovim Config

Personal Neovim configuration written entirely in Lua. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management and **gruvbox** as the default color scheme.

## Structure

```
init.lua                          # Entry point
lua/
├── settings/                     # Core options (indent, search, folds, undodir)
├── mappings/                     # Keymaps (leader: Space, localleader: \)
├── plugin-manager/lazy/          # lazy.nvim bootstrap + plugin specs
├── lsp/
│   ├── language-servers.lua      # lspconfig for all servers
│   └── nvim-cmp.lua              # Completion (nvim-cmp + LuaSnip + lspkind)
└── config/<plugin>/init.lua      # Per-plugin configuration
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
| indentLine | Indent guides |
| nvim-colorizer | Inline color preview |
| twilight | Dim inactive code |

### Editor

| Plugin | Purpose |
|--------|---------|
| treesitter | Syntax highlighting, folding, refactor, autotag |
| telescope | Fuzzy finder (files, grep, buffers, git branches, diagnostics) |
| nvim-surround | Surround text objects |
| vim-commentary | Toggle comments |
| lexima | Auto pairs |
| spectre | Search and replace |
| undotree | Undo history |
| vim-tmux-navigator | Seamless tmux/nvim navigation |
| floaterm | Floating terminal |
| vim-be-good | Practice game |

### Git

| Plugin | Purpose |
|--------|---------|
| vim-fugitive | Git commands |
| git-blame | Inline git blame |
| gitsigns | Git signs in gutter |

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
| neotest | Test runner (Go, Jest, Vitest) |
| pomo | Pomodoro timer |

## LSP Servers

astro, cssls, dockerls, glsl_analyzer, golangci_lint_ls, gopls, html, jsonls, lua_ls, pyright, ts_ls

## Formatters & Linters

| Tool | Languages |
|------|-----------|
| stylua | Lua |
| prettierd | JS/TS/CSS/HTML |
| goimports_reviser + golines | Go |
| golangci_lint | Go |
| glslc | GLSL |
| yamllint | YAML |

## Key Mappings

Leader key is `<Space>`.

### General

| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<leader>wq` | Save & quit |
| `<leader>cl` | Clear search highlight |
| `<leader>tt` | Open terminal tab |
| `<leader>ca` | Code action |
| `<leader>ut` | Undo tree |

### Navigation & Buffers

| Key | Action |
|-----|--------|
| `<leader>,` / `<leader>.` | Previous / next buffer |
| `<leader>!` - `<leader>)` | Go to buffer 1-9 / last |
| `<C-p>` | Pick buffer |
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
| `<leader>dd` | Diagnostics |
| `<leader>gr` | LSP references |
| `<leader>ds` | Document symbols |
| `<leader>gc` | Git branches |
| `cc` | Conventional commit (type + gitmoji + scope + message) |

### Git (Fugitive)

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gm` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gdf` | Git diff split |
| `<leader>gst` / `<leader>gsp` | Stash / stash pop |

### AI

| Key | Action |
|-----|--------|
| `<leader>cp` | Open CopilotChat |
| `<leader>prd` | Generate PR description |
| `<leader>cmsg` | Generate commit message |

### Testing

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
- Node.js (for prettierd, LSP servers)
- Go (for Go tooling)
- stylua (for Lua formatting)
