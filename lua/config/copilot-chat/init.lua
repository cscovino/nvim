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
  model = 'claude-opus-4.5',

  system_prompt = system_prompt,

  sticky = {
    '##neovim://workspace',
    '##neovim://buffer',
  },

  prompts = {
    PRDesc = {
      prompt = 'Give a PR description based on the staged changes and use the template that is in the folder .github/',
      description = 'Generate a PR description based on the staged changes and the template in .github/',
      resources = {
        'gitdiff:staged',
        'file:.github/pull_request_template.md',
      },
      mapping = '<leader>prd',
    },
    Commit = {
      prompt = 'Write commit message for the change with commitizen convention. Write only the title',
      resources = {
        'gitdiff:staged',
      },
      mapping = '<leader>cmsg',
    },
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
