-- Each prompt's condition fills these and its content reads them, so git runs once per prompt.
local diff, template

local function staged_diff()
  -- String form on purpose: through the shell a missing git is exit 127 + "command not found";
  -- the list form would throw E475 instead.
  local out = vim.fn.system('git diff --no-ext-diff --staged')
  if vim.v.shell_error ~= 0 then
    -- First line only: outside a repo git follows its error with ~100 lines of usage.
    local reason = vim.split(vim.trim(out), '\n')[1]
    vim.notify('CodeCompanion: git diff --staged failed: ' .. reason, vim.log.levels.WARN)
    return nil
  end
  return out
end

local function read_file(path)
  local f = io.open(path, 'r')
  if not f then
    return nil
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
          condition = function()
            template = read_file('.github/pull_request_template.md')
            if not template then
              vim.notify(
                'CodeCompanion: .github/pull_request_template.md not found, PR description not generated',
                vim.log.levels.WARN
              )
              return false
            end
            diff = staged_diff()
            return diff ~= nil
          end,
          content = function()
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
              diff
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
          condition = function()
            diff = staged_diff()
            return diff ~= nil
          end,
          content = function()
            return string.format(
              [[Write a commit message for the change with the commitizen convention. Write only the title.

```diff
%s
```]],
              diff
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
