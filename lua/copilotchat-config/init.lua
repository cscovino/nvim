local copilot = require('CopilotChat')

copilot.setup({
  model = 'claude-sonnet-4', -- Specify the model

  window = {
    layout = 'float',
    width = 0.5, -- Fixed width in columns
    height = 0.5, -- Fixed height in rows
    border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
    title = '😎 AI Assistant',
    zindex = 100, -- Ensure window stays on top
  },

  headers = {
    user = '🤓 You: ',
    assistant = '🤖 Copilot: ',
    tool = '🔧 Tool: ',
  },

  separator = '━━',

  mappings = {
    complete = {
      insert = '<C-s>',
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-Space>',
    },
  },
})
