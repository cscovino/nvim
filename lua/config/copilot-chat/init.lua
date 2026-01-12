local copilot = require('CopilotChat')

local system_prompt = require('CopilotChat.config.prompts').COPILOT_INSTRUCTIONS.system_prompt
system_prompt = system_prompt
  .. '\nYou are a helpful AI assistant integrated into Neovim. Use the files in the current working directory and subdirectories to answer my questions.'
system_prompt = system_prompt
  .. '\nDo not print your thoughts, only print the final answer. Unless I ask you to do so explicitly.'
system_prompt = system_prompt
  .. '\nDo not print the tools used in the final answer. Unless I ask you to do so explicitly.'
system_prompt = system_prompt
  .. '\nDo not print the content of files, only use them to answer my question. Unless I ask you to do so explicitly.'

copilot.setup({
  model = 'claude-sonnet-4.5',

  system_prompt = system_prompt,

  sticky = {
    '##neovim://workspace',
    '##neovim://buffer',
  },

  window = {
    layout = 'horizontal',
    width = 1, -- Fixed width in columns
    height = 0.6, -- Fixed height in rows
    -- Only applies to 'float' layout
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
