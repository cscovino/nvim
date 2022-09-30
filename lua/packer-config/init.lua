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
  use('nvim-lualine/lualine.nvim')
  use('romgrk/barbar.nvim')

  -- IDE plugins
  use('nvim-treesitter/nvim-treesitter')
  use('nvim-treesitter/nvim-treesitter-refactor')
  -- use('folke/twilight.nvim')
  use('folke/trouble.nvim')
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
  use('sunjon/shade.nvim')
  use('tpope/vim-fugitive')
  use('mbbill/undotree')
  use('Yggdroot/indentLine')

  -- File Explorer plugins
  use({ 'kyazdani42/nvim-tree.lua', run = ':TSUpdate' })
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } },
  })
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
  use('christoomey/vim-tmux-navigator')

  -- LSP plugins
  use('neovim/nvim-lspconfig')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('saadparwaiz1/cmp_luasnip')
  use('L3MON4D3/LuaSnip')
end)
