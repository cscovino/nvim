return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- Game plugin
  use('ThePrimeagen/vim-be-good')

  -- Style plugins
  use('EdenEast/nightfox.nvim')
  use('ellisonleao/gruvbox.nvim')
  use('folke/tokyonight.nvim')
  use({ 'catppuccin/nvim', as = 'catppuccin' })
  use('kyazdani42/nvim-web-devicons')
  use('onsails/lspkind.nvim')
  use('rcarriga/nvim-notify')
  use('romgrk/barbar.nvim')
  use('stevearc/dressing.nvim')
  use('glepnir/oceanic-material')
  use('Yggdroot/indentLine')
  use('voldikss/vim-floaterm')
  use('nvim-lualine/lualine.nvim')
  -- use({
  --   'folke/noice.nvim',
  --   event = 'VimEnter',
  --   config = function()
  --     require('noice').setup()
  --   end,
  --   requires = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  -- })

  -- IDE plugins
  use('nvim-treesitter/nvim-treesitter')
  use('nvim-treesitter/nvim-treesitter-refactor')
  -- use('folke/twilight.nvim')
  -- use('folke/trouble.nvim')
  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  })
  use('windwp/nvim-ts-autotag')
  use('nvim-treesitter/nvim-treesitter-context')
  use('tpope/vim-commentary')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('jose-elias-alvarez/null-ls.nvim')
  use('APZelos/blamer.nvim')
  use('tpope/vim-fugitive')
  use('mbbill/undotree')
  use('cohama/lexima.vim')
  use({
    'NTBBloodbath/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  })
  use({
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-vim-test',
      'haydenmeade/neotest-jest',
      'marilari88/neotest-vitest',
    },
  })
  -- use({
  --   'phaazon/mind.nvim',
  --   branch = 'v2.2',
  --   requires = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('mind').setup()
  --   end,
  -- })

  -- File Explorer plugins
  use({ 'kyazdani42/nvim-tree.lua', run = ':TSUpdate' })
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } },
  })
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
  use('nvim-telescope/telescope-ui-select.nvim')
  use('christoomey/vim-tmux-navigator')

  -- LSP plugins
  use('neovim/nvim-lspconfig')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lua')
  use('saadparwaiz1/cmp_luasnip')
  use('L3MON4D3/LuaSnip')
end)
