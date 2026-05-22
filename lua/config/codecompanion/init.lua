local function staged_diff()
  return vim.fn.system('git diff --no-ext-diff --staged')
end

local function read_file(path)
  local f = io.open(path, 'r')
  if not f then
    return ''
  end
  local content = f:read('*a')
  f:close()
  return content
end

require('codecompanion').setup({
  adapters = {
    opts = {
      show_defaults = true,
    },
    http = {
      copilot = function()
        return require('codecompanion.adapters').extend('copilot', {
          schema = {
            model = {
              default = 'claude-opus-4.6',
            },
          },
        })
      end,
    },
  },

  interactions = {
    chat = {
      adapter = 'copilot',
      keymaps = {
        send = {
          modes = { n = '<CR>', i = '<C-Space>' },
        },
        close = {
          modes = { n = 'q' },
        },
      },
    },
    inline = { adapter = 'copilot' },
    cmd = { adapter = 'copilot' },
    cli = {
      agent = 'claude_code',
      agents = {
        claude_code = {
          cmd = 'env',
          args = { 'CODECOMPANION_CLI=1', 'claude' },
          description = 'Claude Code CLI',
          provider = 'terminal',
        },
        opencode = {
          cmd = 'env',
          args = { 'CODECOMPANION_CLI=1', 'opencode' },
          description = 'OpenCode CLI',
          provider = 'terminal',
        },
      },
    },
  },

  prompt_library = {
    ['PR Description'] = {
      interaction = 'chat',
      description = 'Generate a PR description from staged changes and the template in .github/',
      opts = {
        alias = 'prd',
        is_slash_cmd = true,
        auto_submit = true,
      },
      prompts = {
        {
          role = 'user',
          content = function()
            local template = read_file('.github/pull_request_template.md')
            return string.format(
              [[Give a PR description based on the staged changes and use the template that is in the folder .github/.

## PR template

```markdown
%s
```

## Staged diff

```diff
%s
```]],
              template,
              staged_diff()
            )
          end,
          opts = { contains_code = true },
        },
      },
    },

    ['Commit Message'] = {
      interaction = 'chat',
      description = 'Generate a conventional commit title for staged changes',
      opts = {
        alias = 'cmg',
        is_slash_cmd = true,
        auto_submit = true,
      },
      prompts = {
        {
          role = 'user',
          content = function()
            return string.format(
              [[Write a commit message for the change with the commitizen convention. Write only the title.

```diff
%s
```]],
              staged_diff()
            )
          end,
          opts = { contains_code = true },
        },
      },
    },
  },

  display = {
    chat = {
      window = {
        layout = 'vertical',
        width = 0.4,
        border = 'rounded',
        title = '😎 AI Assistant',
      },
      icons = {
        chat_context = '📎 ',
      },
    },
    action_palette = {
      provider = 'snacks',
    },
    diff = {
      provider = 'default',
    },
  },
})

require('config.codecompanion.notifier').setup()
