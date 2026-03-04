require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'astro',
    'bash',
    'css',
    'dockerfile',
    'gitignore',
    'glsl',
    'go',
    'html',
    'http',
    'javascript',
    'json',
    'lua',
    'markdown',
    'python',
    'regex',
    'scss',
    'typescript',
  },

  sync_install = false,
  auto_install = true,
  ignore_install = {},

  modules = {},

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
  },
})
