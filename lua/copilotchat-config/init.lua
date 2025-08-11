local copilot = require('CopilotChat')

copilot.setup({
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
      callback = function()
        copilot.trigger_complete()
      end,
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-Space>',
      callback = function()
        local message = copilot.chat:get_closest_message('user')
        if not message then
          return
        end

        copilot.ask(message.content)
      end,
    },
  },
})
