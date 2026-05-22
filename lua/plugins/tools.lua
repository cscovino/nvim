return {
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
  { 'ThePrimeagen/vim-be-good', cmd = 'VimBeGood' },
}
