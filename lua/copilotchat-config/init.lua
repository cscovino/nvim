local copilot = require('CopilotChat')

copilot.setup({
  model = 'claude-sonnet-4', -- Specify the model

  window = {
    layout = 'float',
    width = 0.8, -- Fixed width in columns
    height = 0.8, -- Fixed height in rows
    border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
    title = '😎 AI Assistant',
    zindex = 1, -- Ensure window stays on top
  },

  headers = {
    user = '🤓 You: ',
    assistant = '🤖 Copilot: ',
    tool = '🔧 Tool: ',
  },

  separator = '━━',

  mappings = {
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-Space>',
    },
  },
})
