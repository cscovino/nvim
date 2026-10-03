return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      require('lsp.language-servers')
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    -- The copilot source needs copilot.lua, which only the ai category installs.
    dependencies = require('profile').enabled('ai') and { 'giuxtaposition/blink-cmp-copilot' } or nil,
    opts = function()
      return require('config.blink')
    end,
    opts_extend = { 'sources.default' },
  },
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    config = function()
      require('config.conform')
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost', 'BufReadPost' },
    config = function()
      require('config.lint')
    end,
  },
}
