local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = '\\' -- Same for `maplocalleader`

require('lazy').setup({
  spec = {
    -- Copilot plugin
    'github/copilot.vim',
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      branch = 'canary',
      dependencies = {
        { 'github/copilot.vim' },
        { 'nvim-lua/plenary.nvim' },
      },
      build = 'make tiktoken',
    },
    -- Game plugin
    'ThePrimeagen/vim-be-good',

    -- Style plugins
    'EdenEast/nightfox.nvim',
    { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
    'folke/tokyonight.nvim',
    { 'catppuccin/nvim', as = 'catppuccin' },
    'nvim-tree/nvim-web-devicons',
    'onsails/lspkind.nvim',
    'romgrk/barbar.nvim',
    'glepnir/oceanic-material',
    'Yggdroot/indentLine',
    'voldikss/vim-floaterm',
    'norcalli/nvim-colorizer.lua',
    'nvim-lualine/lualine.nvim',
    {
      'folke/noice.nvim',
      event = 'VeryLazy',
      opts = {
        -- add any options here
      },
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        'MunifTanjim/nui.nvim',
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        'rcarriga/nvim-notify',
      },
    },
    'xiyaowong/nvim-transparent',

    -- IDE plugins
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-refactor',
    -- 'folke/twilight.nvim',
    -- 'folke/trouble.nvim',
    {
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu',
    },
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context',
    'tpope/vim-commentary',
    'JoosepAlviste/nvim-ts-context-commentstring',
    { 'nvimtools/none-ls.nvim', dependencies = { 'nvimtools/none-ls-extras.nvim' } },
    'APZelos/blamer.nvim',
    'tpope/vim-fugitive',
    'nvim-pack/nvim-spectre',
    'mbbill/undotree',
    'cohama/lexima.vim',
    'nvim-neotest/nvim-nio',
    {
      'kylechui/nvim-surround',
      version = '*', -- Use for stability; omit to use `main` branch for the latest features
      event = 'VeryLazy',
      config = function()
        require('nvim-surround').setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    },
    {
      'vhyrro/luarocks.nvim',
      priority = 1000,
      config = true,
      opts = {
        rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' },
      },
    },
    {
      'rest-nvim/rest.nvim',
      ft = 'http',
      dependencies = { 'luarocks.nvim' },
      config = function()
        require('rest-nvim').setup()
      end,
    },
    {
      'nvim-neotest/neotest',
      requires = {
        'nvim-neotest/nvim-nio',
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
    },
    -- {
    --   'phaazon/mind.nvim',
    --   branch = 'v2.2',
    --   requires = { 'nvim-lua/plenary.nvim' },
    --   config = function()
    --     require('mind').setup()
    --   end,
    -- },

    -- File Explorer plugins
    { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.6',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    'nvim-telescope/telescope-ui-select.nvim',
    {
      'olacin/telescope-gitmoji.nvim',
      config = function()
        require('telescope').load_extension('gitmoji')
      end,
      dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    },
    { 'olacin/telescope-cc.nvim' },
    'christoomey/vim-tmux-navigator',

    -- LSP plugins
    'neovim/nvim-lspconfig',
    'L3MON4D3/LuaSnip',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'saadparwaiz1/cmp_luasnip',
  },
})
