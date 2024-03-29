return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- Game plugin
  use('ThePrimeagen/vim-be-good')

  -- Style plugins
  use('EdenEast/nightfox.nvim')
  use('ellisonleao/gruvbox.nvim')
  use('folke/tokyonight.nvim')
  use({ 'catppuccin/nvim', as = 'catppuccin' })
  use('nvim-tree/nvim-web-devicons')
  use('onsails/lspkind.nvim')
  use('romgrk/barbar.nvim')
  use('glepnir/oceanic-material')
  use('Yggdroot/indentLine')
  use('voldikss/vim-floaterm')
  use('norcalli/nvim-colorizer.lua')
  use('nvim-lualine/lualine.nvim')
  use({
    'folke/noice.nvim',
    event = 'VimEnter',
    config = function()
      require('noice').setup()
    end,
    requires = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  })
  use('xiyaowong/nvim-transparent')

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
    'kylechui/nvim-surround',
    tag = '*',
    config = function()
      require('nvim-surround').setup({})
    end,
  })
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
      -- 'nvim-neotest/neotest-vim-test',
      'nvim-neotest/neotest-go',
      -- 'haydenmeade/neotest-jest',
      'marilari88/neotest-vitest',
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)
      local neotest = require('neotest')
      neotest.setup({
        -- your neotest config here
        adapters = {
          require('neotest-go'),
        },
        consumers = {
          always_open_output = function(client)
            local async = require('neotest.async')

            client.listeners.results = function(adapter_id, results)
              local file_path = async.fn.expand('%:p')
              local row = async.fn.getpos('.')[2] - 1
              local position = client:get_nearest(file_path, row, {})
              if not position then
                return
              end
              local pos_id = position:data().id
              if not results[pos_id] then
                return
              end
              neotest.output_panel.open({ position_id = pos_id, adapter = adapter_id })
            end
          end,
        },
      })
    end,
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
  use({ 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } })
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
  use('L3MON4D3/LuaSnip')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lua')
  use('saadparwaiz1/cmp_luasnip')
end)
