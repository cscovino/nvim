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

require('lazy').setup({
  spec = {
    -- Copilot plugin
    {
      'github/copilot.vim',
      event = 'InsertEnter',
      init = function()
        vim.g.copilot_no_tab_map = true
      end,
      config = function()
        vim.keymap.set(
          'i',
          '<S-Tab><S-Tab>',
          'copilot#Accept("\\<S-Tab>")',
          { expr = true, replace_keycodes = false }
        )
      end,
    },
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      cmd = 'CopilotChat',
      keys = {
        { '<leader>cp', '<Cmd>CopilotChat<CR>', desc = 'CopilotChat' },
        { '<leader>prd', desc = 'PR Description' },
        { '<leader>cmsg', desc = 'Commit Message' },
      },
      dependencies = {
        { 'github/copilot.vim' },
        { 'nvim-lua/plenary.nvim', branch = 'master' },
      },
      build = 'make tiktoken',
      config = function()
        require('config.copilot-chat')
      end,
    },

    -- MCP Hub
    {
      'ravitemer/mcphub.nvim',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      build = 'npm install -g mcp-hub@latest',
      config = function()
        require('config.mcp-hub')
      end,
    },

    -- Game plugin
    -- { 'ThePrimeagen/vim-be-good', cmd = 'VimBeGood' },

    -- Style plugins
    -- { 'EdenEast/nightfox.nvim', lazy = true },
    { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
    -- { 'folke/tokyonight.nvim', lazy = true },
    -- { 'catppuccin/nvim', as = 'catppuccin', lazy = true },
    'nvim-tree/nvim-web-devicons',
    -- { 'glepnir/oceanic-material', lazy = true },
    {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      event = 'BufReadPost',
      opts = {
        indent = { char = { '|', '¦', '┆', '┊' } },
      },
    },
    {
      'akinsho/toggleterm.nvim',
      version = '*',
      cmd = 'ToggleTerm',
      keys = {
        { '<leader>tt', '<Cmd>ToggleTerm direction=float<CR>', desc = 'Toggle terminal' },
      },
      opts = {
        open_mapping = false,
        direction = 'float',
      },
    },
    { 'NvChad/nvim-colorizer.lua', event = 'BufReadPost', opts = {} },
    {
      'nvim-lualine/lualine.nvim',
      event = 'VeryLazy',
      config = function()
        require('config.lualine')
      end,
    },
    {
      'rcarriga/nvim-notify',
      lazy = true,
      opts = { background_colour = '#000' },
    },
    {
      'folke/noice.nvim',
      event = 'VeryLazy',
      opts = {
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          command_palette = true,
          long_message_to_split = true,
        },
      },
      dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
      },
    },
    {
      'xiyaowong/nvim-transparent',
      event = 'VeryLazy',
      config = function()
        require('config.transparent')
      end,
    },
    {
      'romgrk/barbar.nvim',
      event = 'BufReadPost',
      dependencies = {
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      keys = {
        { '<leader>,', '<Cmd>BufferPrevious<CR>', desc = 'Buffer previous' },
        { '<leader>.', '<Cmd>BufferNext<CR>', desc = 'Buffer next' },
        { '<leader><', '<Cmd>BufferMovePrevious<CR>', desc = 'Buffer move prev' },
        { '<leader>>', '<Cmd>BufferMoveNext<CR>', desc = 'Buffer move next' },
        { '<leader>!', '<Cmd>BufferGoto 1<CR>', desc = 'Buffer 1' },
        { '<leader>@', '<Cmd>BufferGoto 2<CR>', desc = 'Buffer 2' },
        { '<leader>#', '<Cmd>BufferGoto 3<CR>', desc = 'Buffer 3' },
        { '<leader>$', '<Cmd>BufferGoto 4<CR>', desc = 'Buffer 4' },
        { '<leader>%', '<Cmd>BufferGoto 5<CR>', desc = 'Buffer 5' },
        { '<leader>^', '<Cmd>BufferGoto 6<CR>', desc = 'Buffer 6' },
        { '<leader>&', '<Cmd>BufferGoto 7<CR>', desc = 'Buffer 7' },
        { '<leader>*', '<Cmd>BufferGoto 8<CR>', desc = 'Buffer 8' },
        { '<leader>(', '<Cmd>BufferGoto 9<CR>', desc = 'Buffer 9' },
        { '<leader>)', '<Cmd>BufferLast<CR>', desc = 'Buffer last' },
        { '<leader>bp', '<Cmd>BufferPin<CR>', desc = 'Buffer pin' },
        { '<leader>bc', '<Cmd>BufferClose<CR>', desc = 'Buffer close' },
        { '<leader>abc', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = 'Close other buffers' },
        { '<C-p>', '<Cmd>BufferPick<CR>', desc = 'Buffer pick' },
        { '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', desc = 'Order by number' },
        { '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', desc = 'Order by directory' },
        { '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', desc = 'Order by language' },
        { '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', desc = 'Order by window' },
      },
      config = function()
        require('config.barbar')
      end,
    },

    -- IDE plugins
    {
      'nvim-treesitter/nvim-treesitter',
      event = 'BufReadPost',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-refactor',
      },
      config = function()
        require('config.treesitter')
      end,
    },
    {
      'windwp/nvim-ts-autotag',
      event = 'BufReadPost',
      opts = {},
    },
    { 'nvim-treesitter/nvim-treesitter-context', event = 'BufReadPost' },
    {
      'folke/twilight.nvim',
      cmd = 'Twilight',
      keys = {
        { '<leader>tw', '<Cmd>Twilight<CR>', desc = 'Toggle Twilight' },
      },
      config = function()
        require('config.twilight')
      end,
    },
    -- 'folke/trouble.nvim',
    -- Code actions: using built-in vim.lsp.buf.code_action()
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
    {
      'f-person/git-blame.nvim',
      event = 'VeryLazy',
      opts = {
        enabled = true,
        message_template = ' <summary> • <date> • <author> • <<sha>>',
        date_format = '%d-%m-%Y %H:%M',
        virtual_text_column = 1,
      },
    },
    {
      'tpope/vim-fugitive',
      cmd = { 'G', 'Git', 'Gdiffsplit' },
      keys = {
        { '<leader>gj', '<Cmd>diffget //3<CR>', desc = 'Diffget right' },
        { '<leader>gf', '<Cmd>diffget //2<CR>', desc = 'Diffget left' },
        { '<leader>gs', '<Cmd>G<CR>', desc = 'Git status' },
        { '<leader>gm', '<Cmd>G commit<CR>', desc = 'Git commit' },
        { '<leader>gp', '<Cmd>G push<CR>', desc = 'Git push' },
        { '<leader>gl', '<Cmd>G pull<CR>', desc = 'Git pull' },
        { '<leader>gst', '<Cmd>G stash<CR>', desc = 'Git stash' },
        { '<leader>gsp', '<Cmd>G stash pop<CR>', desc = 'Git stash pop' },
        { '<leader>gdf', '<Cmd>Gdiffsplit<CR>', desc = 'Git diff split' },
      },
    },
    {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      keys = {
        { '<leader>dv', '<Cmd>DiffviewOpen<CR>', desc = 'Diffview open' },
        { '<leader>dh', '<Cmd>DiffviewFileHistory %<CR>', desc = 'Diffview file history' },
      },
      opts = {},
    },
    {
      'MagicDuck/grug-far.nvim',
      cmd = 'GrugFar',
      keys = {
        {
          '<leader>rp',
          function()
            require('grug-far').open()
          end,
          desc = 'Search and replace (grug-far)',
        },
      },
      opts = {},
    },
    { 'mbbill/undotree', cmd = 'UndotreeShow' },
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        local autopairs = require('nvim-autopairs')
        autopairs.setup({})
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end,
    },
    { 'nvim-neotest/nvim-nio', lazy = true },
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
      'folke/flash.nvim',
      event = 'VeryLazy',
      opts = {},
      keys = {
        {
          's',
          mode = { 'n', 'x', 'o' },
          function()
            require('flash').jump()
          end,
          desc = 'Flash',
        },
        {
          'S',
          mode = { 'n', 'x', 'o' },
          function()
            require('flash').treesitter()
          end,
          desc = 'Flash Treesitter',
        },
        {
          '<c-s>',
          mode = { 'c' },
          function()
            require('flash').toggle()
          end,
          desc = 'Toggle Flash Search',
        },
      },
    },
    {
      'vhyrro/luarocks.nvim',
      lazy = true,
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
        require('config.rest')
      end,
    },
    {
      'nvim-neotest/neotest',
      keys = {
        {
          '<leader>ts',
          function()
            require('neotest').summary.toggle()
            local win = vim.fn.bufwinid('Neotest Summary')
            if win > -1 then
              vim.api.nvim_set_current_win(win)
            end
          end,
          desc = 'Toggle test summary',
        },
        {
          '<leader>to',
          function()
            require('neotest').output_panel.toggle()
            local win = vim.fn.bufwinid('Neotest Output Panel')
            if win > -1 then
              vim.api.nvim_set_current_win(win)
            end
          end,
          desc = 'Toggle test output',
        },
        {
          '<leader>rt',
          function()
            require('neotest').run.run()
          end,
          desc = 'Run nearest test',
        },
      },
      dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-neotest/neotest-plenary',
        -- 'nvim-neotest/neotest-vim-test',
        'nvim-neotest/neotest-go',
        'nvim-neotest/neotest-jest',
        'marilari88/neotest-vitest',
      },
      config = function()
        require('config.neotest')
      end,
    },

    -- Productivity plugins
    {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
        triggers = {},
      },
      config = function(_, opts)
        local wk = require('which-key')
        wk.setup(opts)
        wk.add({
          { '<leader>?', function() wk.show({ keys = '<leader>', loop = true }) end, desc = 'Show all keymaps' },
          { '<leader>b', group = 'Buffer' },
          { '<leader>c', group = 'Code/Copilot' },
          { '<leader>d', group = 'Diff/Diagnostics' },
          { '<leader>f', group = 'Find/Format' },
          { '<leader>g', group = 'Git' },
          { '<leader>n', group = 'NvimTree/Navigate' },
          { '<leader>p', group = 'PR/Diagnostic' },
          { '<leader>r', group = 'Run/Replace/Rename' },
          { '<leader>s', group = 'Session' },
          { '<leader>t', group = 'Test/Toggle' },
          { '<leader>w', group = 'Save/Workspace' },
        })
      end,
    },
    {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = {},
      keys = {
        {
          '<leader>ss',
          function()
            require('persistence').load()
          end,
          desc = 'Restore session',
        },
        {
          '<leader>sd',
          function()
            require('persistence').stop()
          end,
          desc = 'Stop session auto-save',
        },
      },
    },
    {
      'epwalsh/pomo.nvim',
      version = '*',
      lazy = true,
      cmd = { 'TimerStart', 'TimerRepeat', 'TimerSession' },
      dependencies = {
        'rcarriga/nvim-notify',
      },
      config = function()
        require('config.pomo')
      end,
    },

    -- File Explorer plugins
    {
      'nvim-tree/nvim-tree.lua',
      cmd = 'NvimTreeToggle',
      keys = {
        { '<leader>nt', '<Cmd>NvimTreeToggle<CR>', desc = 'Toggle NvimTree' },
      },
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('config.nvimtree')
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = {
        { '<leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'Find files' },
        { '<leader>fg', '<Cmd>Telescope live_grep<CR>', desc = 'Live grep' },
        { '<leader>fb', '<Cmd>Telescope buffers<CR>', desc = 'Buffers' },
        { '<leader>fh', '<Cmd>Telescope help_tags<CR>', desc = 'Help tags' },
        { '<leader>cs', '<Cmd>Telescope colorscheme<CR>', desc = 'Colorscheme' },
        { '<leader>ch', '<Cmd>Telescope command_history<CR>', desc = 'Command history' },
        { '<leader>gc', '<Cmd>Telescope git_branches<CR>', desc = 'Git branches' },
        { '<leader>dd', '<Cmd>Telescope diagnostics<CR>', desc = 'Diagnostics' },
        { '<leader>gr', '<Cmd>Telescope lsp_references<CR>', desc = 'LSP references' },
        { '<leader>ds', '<Cmd>Telescope lsp_document_symbols<CR>', desc = 'Document symbols' },
        {
          'cc',
          function()
            require('config.telescope').create_conventional_commit()
          end,
          desc = 'Conventional commit',
        },
      },
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
        {
          'olacin/telescope-gitmoji.nvim',
          dependencies = { 'nvim-lua/plenary.nvim' },
        },
        'olacin/telescope-cc.nvim',
      },
      config = function()
        require('config.telescope')
      end,
    },
    'christoomey/vim-tmux-navigator',

    -- LSP plugins
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = { 'hrsh7th/cmp-nvim-lsp' },
      config = function()
        require('lsp.language-servers')
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        {
          'L3MON4D3/LuaSnip',
          version = 'v2.*',
          build = 'make install_jsregexp',
        },
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        'onsails/lspkind.nvim',
      },
      config = function()
        require('lsp.nvim-cmp')
      end,
    },
  },
})
