return {
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
              require('treesitter-context.config').update({ max_lines = n }) ---@diagnostic disable-line: undefined-field
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
  'christoomey/vim-tmux-navigator',
}
