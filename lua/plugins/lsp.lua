return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
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
      return require('config.blink')
    end,
    opts_extend = { 'sources.default' },
  },
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
  { 'nvim-neotest/nvim-nio', lazy = true },
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
}
