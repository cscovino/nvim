return {
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
    init = function()
      vim.g.transparent_enabled = true
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
        sources = {
          explorer = {
            jump = { close = true },
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
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find files',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Live grep',
      },
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help tags',
      },
      {
        '<leader>cs',
        function()
          Snacks.picker.colorschemes()
        end,
        desc = 'Colorscheme',
      },
      {
        '<leader>ch',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command history',
      },
      {
        '<leader>gc',
        function()
          Snacks.picker.git_branches({ all = true })
        end,
        desc = 'Git branches',
      },
      {
        '<leader>dd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Diagnostics',
      },
      {
        '<leader>gr',
        function()
          Snacks.picker.lsp_references()
        end,
        desc = 'LSP references',
      },
      {
        '<leader>ds',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'Document symbols',
      },
      {
        '<leader>nt',
        function()
          Snacks.explorer()
        end,
        desc = 'Toggle file explorer',
      },
      {
        '<leader>tt',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle terminal',
      },
      {
        '<leader>fN',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification history',
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git status',
      },
      {
        '<leader>gi',
        function()
          Snacks.picker.gh_issue()
        end,
        desc = 'GitHub issues',
      },
      {
        '<leader>gp',
        function()
          Snacks.picker.gh_pr()
        end,
        desc = 'GitHub PRs',
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git blame line (popup)',
      },
      {
        '<leader>gl',
        function()
          Snacks.terminal('git pull')
        end,
        desc = 'Git pull',
      },
      {
        '<leader>gP',
        function()
          Snacks.terminal('git push')
        end,
        desc = 'Git push',
      },
      {
        '<leader>gz',
        function()
          Snacks.terminal('git stash')
        end,
        desc = 'Git stash',
      },
      {
        '<leader>gZ',
        function()
          Snacks.terminal('git stash pop')
        end,
        desc = 'Git stash pop',
      },
      {
        'cc',
        function()
          require('config.commits').create_conventional_commit()
        end,
        desc = 'Conventional commit',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', { ---@diagnostic disable-line: param-type-mismatch
        pattern = 'VeryLazy',
        callback = function()
          vim.ui.select = Snacks.picker.select
        end,
      })
    end,
  },
}
