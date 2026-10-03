return {
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
}
