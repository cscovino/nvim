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
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = { ['*'] = true },
      },
    },
    {
      'olimorris/codecompanion.nvim',
      version = '^19.0.0',
      cmd = {
        'CodeCompanion',
        'CodeCompanionChat',
        'CodeCompanionActions',
        'CodeCompanionCmd',
        'CodeCompanionCLI',
      },
      keys = {
        { '<leader>ac', '<Cmd>CodeCompanionChat Toggle<CR>', desc = 'Agent chat' },
        { '<leader>aa', '<Cmd>CodeCompanionActions<CR>', desc = 'Agent actions' },
        { '<leader>apd', '<Cmd>CodeCompanion /prd<CR>', desc = 'Agent PR description' },
        { '<leader>amg', '<Cmd>CodeCompanion /cmg<CR>', desc = 'Agent commit message' },
        {
          '<leader>ai',
          '<Cmd>CodeCompanion<CR>',
          mode = { 'v' },
          desc = 'Agent inline (visual)',
        },
        {
          '<leader>at',
          function()
            local agents = vim.tbl_keys(require('codecompanion.config').interactions.cli.agents)
            table.sort(agents)
            vim.ui.select(agents, { prompt = 'CodeCompanion CLI agent:' }, function(choice)
              if not choice then
                return
              end
              local cli = require('codecompanion.interactions.cli')
              local existing = cli.find_by_agent(choice)
              if existing then
                if existing.ui:is_visible() then
                  existing.ui:hide()
                else
                  existing.ui:open()
                end
                return
              end
              local instance = cli.create({ agent = choice })
              if instance then
                instance.ui:open()
              end
            end)
          end,
          desc = 'Agent toggle CLI (pick agent)',
        },
      },
      dependencies = {
        'zbirenbaum/copilot.lua',
        { 'nvim-lua/plenary.nvim', branch = 'master' },
        'nvim-treesitter/nvim-treesitter',
      },
      config = function()
        require('config.codecompanion')
      end,
    },

    -- MCP Hub
    {
      'ravitemer/mcphub.nvim',
      cmd = 'MCPHub',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      build = 'pnpm add -g mcp-hub@latest',
      config = function()
        require('config.mcp-hub')
      end,
    },

    -- Game plugins
    { 'ThePrimeagen/vim-be-good', cmd = 'VimBeGood' },

    -- Style plugins
    { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
    { 'EdenEast/nightfox.nvim', lazy = true },
    { 'folke/tokyonight.nvim', lazy = true },
    { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
    'nvim-tree/nvim-web-devicons',
    {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      event = 'BufReadPost',
      opts = {
        indent = { char = { '|', '¦', '┆', '┊' } },
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
      'xiyaowong/nvim-transparent',
      event = 'VeryLazy',
      config = function()
        require('config.transparent')
      end,
    },
    {
      'romgrk/barbar.nvim',
      event = 'VeryLazy',
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
        { '<leader>bo', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = 'Close other buffers' },
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
      branch = 'main',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        require('config.treesitter')
      end,
    },
    {
      'windwp/nvim-ts-autotag',
      event = 'BufReadPost',
      opts = {},
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
      event = 'BufReadPost',
      keys = {
        {
          '<leader>ct',
          function()
            local ok, tsc = pcall(require, 'treesitter-context')
            if ok then
              tsc.toggle()
            end
          end,
          desc = 'Toggle treesitter context',
        },
        {
          '<leader>cml',
          function()
            vim.ui.input({ prompt = 'Context max_lines: ' }, function(input)
              local n = tonumber(input)
              if n and n >= 1 then
                require('treesitter-context.config').update({ max_lines = n })
                vim.notify('Context max_lines set to ' .. n)
              end
            end)
          end,
          desc = 'Set context max lines',
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
      },
      opts = {
        file_types = { 'markdown', 'codecompanion' },
        ignore = function(buf)
          return vim.bo[buf].buftype ~= ''
        end,
      },
    },
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
    {
      'folke/trouble.nvim',
      cmd = 'Trouble',
      keys = {
        { '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
        { '<leader>xd', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer diagnostics (Trouble)' },
        { '<leader>xl', '<Cmd>Trouble loclist toggle<CR>', desc = 'Loclist (Trouble)' },
        { '<leader>xq', '<Cmd>Trouble qflist toggle<CR>', desc = 'Quickfix (Trouble)' },
      },
      opts = {},
    },
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
      'echasnovski/mini.pairs',
      event = 'InsertEnter',
      opts = {},
    },
    { 'nvim-neotest/nvim-nio', lazy = true },

    -- Debug Adapter Protocol (set enabled = false to disable)
    {
      'mfussenegger/nvim-dap',
      enabled = true,
      keys = {
        {
          '<leader>db',
          function()
            require('dap').toggle_breakpoint()
          end,
          desc = 'Toggle breakpoint',
        },
        {
          '<leader>dB',
          function()
            require('dap').set_breakpoint(vim.fn.input('Condition: '))
          end,
          desc = 'Conditional breakpoint',
        },
        {
          '<leader>dc',
          function()
            require('dap').continue()
          end,
          desc = 'Continue / Start',
        },
        {
          '<leader>di',
          function()
            require('dap').step_into()
          end,
          desc = 'Step into',
        },
        {
          '<leader>do',
          function()
            require('dap').step_over()
          end,
          desc = 'Step over',
        },
        {
          '<leader>dO',
          function()
            require('dap').step_out()
          end,
          desc = 'Step out',
        },
        {
          '<leader>dr',
          function()
            require('dap').restart()
          end,
          desc = 'Restart',
        },
        {
          '<leader>dt',
          function()
            require('dap').terminate()
          end,
          desc = 'Terminate',
        },
        {
          '<leader>du',
          function()
            require('dapui').toggle()
          end,
          desc = 'Toggle DAP UI',
        },
        {
          '<leader>de',
          function()
            require('dapui').eval()
          end,
          desc = 'Eval',
          mode = { 'n', 'v' },
        },
      },
      dependencies = {
        {
          'rcarriga/nvim-dap-ui',
          dependencies = { 'nvim-neotest/nvim-nio' },
        },
        {
          'microsoft/vscode-js-debug',
          build = 'npm install --legacy-peer-deps && npx gulp dapDebugServer && rm -rf out && mv dist out',
        },
      },
      config = function()
        require('config.dap')
      end,
    },
    {
      'echasnovski/mini.move',
      event = 'VeryLazy',
      opts = {},
    },
    {
      'echasnovski/mini.ai',
      event = 'BufReadPost',
      opts = { n_lines = 500 },
    },
    {
      'echasnovski/mini.surround',
      event = 'VeryLazy',
      opts = {
        mappings = {
          add = 'ys',
          delete = 'ds',
          find = '',
          find_left = '',
          highlight = '',
          replace = 'cs',
          update_n_lines = '',
          suffix_last = '',
          suffix_next = '',
        },
        search_method = 'cover_or_next',
      },
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
          mode = { 'n', 'o' },
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
          {
            '<leader>?',
            function()
              wk.show({ keys = '<leader>', loop = true })
            end,
            desc = 'Show all keymaps',
          },
          { '<leader>a', group = 'AI' },
          { '<leader>b', group = 'Buffer' },
          { '<leader>c', group = 'Code' },
          { '<leader>d', group = 'Debug/Diff/Diagnostics' },
          { '<leader>f', group = 'Find/Format' },
          { '<leader>g', group = 'Git' },
          { '<leader>n', group = 'NvimTree/Navigate' },
          { '<leader>p', group = 'PR/Diagnostic' },
          { '<leader>r', group = 'Run/Replace/Rename' },
          { '<leader>s', group = 'Session' },
          { '<leader>t', group = 'Test/Toggle' },
          { '<leader>w', group = 'Save/Workspace' },
          { '<leader>x', group = 'Trouble' },
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
        'MunifTanjim/nui.nvim',
      },
      config = function()
        require('config.pomo')
      end,
    },

    -- File Explorer plugins
    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        picker = {
          enabled = true,
          previewers = {
            diff = {
              style = 'fancy',
              wo = {
                wrap = false,
                breakindent = false,
                linebreak = false,
                showbreak = '',
              },
            },
          },
        },
        explorer = { enabled = true },
        notifier = { enabled = true, timeout = 3000 },
        terminal = { enabled = true },
        image = { enabled = true },
        gh = { enabled = true },
        git = { enabled = true },
        lazygit = { enabled = true },
      },
      keys = {
        { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
        { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Live grep' },
        { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<leader>fh', function() Snacks.picker.help() end, desc = 'Help tags' },
        { '<leader>cs', function() Snacks.picker.colorschemes() end, desc = 'Colorscheme' },
        { '<leader>ch', function() Snacks.picker.command_history() end, desc = 'Command history' },
        { '<leader>gc', function() Snacks.picker.git_branches() end, desc = 'Git branches' },
        { '<leader>dd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
        { '<leader>gr', function() Snacks.picker.lsp_references() end, desc = 'LSP references' },
        { '<leader>ds', function() Snacks.picker.lsp_symbols() end, desc = 'Document symbols' },
        { '<leader>nt', function() Snacks.explorer() end, desc = 'Toggle file explorer' },
        { '<leader>tt', function() Snacks.terminal() end, desc = 'Toggle terminal' },
        { '<leader>fN', function() Snacks.notifier.show_history() end, desc = 'Notification history' },
        { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
        { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git status' },
        { '<leader>gi', function() Snacks.picker.gh_issue() end, desc = 'GitHub issues' },
        { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub PRs' },
        { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git blame line (popup)' },
        { '<leader>gl', function() Snacks.terminal('git pull') end, desc = 'Git pull' },
        { '<leader>gP', function() Snacks.terminal('git push') end, desc = 'Git push' },
        {
          'cc',
          function()
            require('config.commits').create_conventional_commit()
          end,
          desc = 'Conventional commit',
        },
      },
      init = function()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'VeryLazy',
          callback = function()
            vim.ui.select = Snacks.picker.select
          end,
        })
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
      dependencies = { 'saghen/blink.cmp' },
      config = function()
        require('lsp.language-servers')
      end,
    },
    {
      'saghen/blink.cmp',
      version = '1.*',
      event = 'InsertEnter',
      dependencies = {
        'giuxtaposition/blink-cmp-copilot',
      },
      opts = function()
        return require('lsp.blink')
      end,
      opts_extend = { 'sources.default' },
    },
  },
  ui = {
    border = 'rounded',
  },
})
