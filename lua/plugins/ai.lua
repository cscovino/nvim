return {
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
}
