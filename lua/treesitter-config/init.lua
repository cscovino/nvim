require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'lua',
    'css',
    'dockerfile',
    'gitignore',
    'go',
    'html',
    'javascript',
    'http',
    'json',
    'markdown',
    'python',
    'typescript',
  },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  autotag = {
    enable = true,
  },

  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = '<leader>rn',
      },
    },
  },
})
