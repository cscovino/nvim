local M = {}

local cc_types = {
  { value = 'feat', description = 'A new feature' },
  { value = 'fix', description = 'A bug fix' },
  { value = 'docs', description = 'Documentation only changes' },
  { value = 'style', description = 'Code style (formatting, missing semicolons, etc.)' },
  { value = 'refactor', description = 'Code refactor without behavior change' },
  { value = 'perf', description = 'Performance improvement' },
  { value = 'test', description = 'Adding or updating tests' },
  { value = 'chore', description = 'Maintenance tasks (deps, tooling)' },
  { value = 'build', description = 'Build system or external deps' },
  { value = 'ci', description = 'CI configuration changes' },
  { value = 'revert', description = 'Reverting a previous commit' },
}

local gitmojis = {
  { emoji = '✨', description = 'Introduce new features' },
  { emoji = '🐛', description = 'Fix a bug' },
  { emoji = '🚑️', description = 'Critical hotfix' },
  { emoji = '🔥', description = 'Remove code or files' },
  { emoji = '📝', description = 'Add or update documentation' },
  { emoji = '💄', description = 'Add or update UI and style files' },
  { emoji = '♻️', description = 'Refactor code' },
  { emoji = '⚡️', description = 'Improve performance' },
  { emoji = '✅', description = 'Add, update, or pass tests' },
  { emoji = '🔧', description = 'Add or update configuration files' },
  { emoji = '🔨', description = 'Add or update development scripts' },
  { emoji = '⬆️', description = 'Upgrade dependencies' },
  { emoji = '⬇️', description = 'Downgrade dependencies' },
  { emoji = '➕', description = 'Add a dependency' },
  { emoji = '➖', description = 'Remove a dependency' },
  { emoji = '📌', description = 'Pin dependencies to specific versions' },
  { emoji = '🎨', description = 'Improve structure / format of the code' },
  { emoji = '🚀', description = 'Deploy stuff' },
  { emoji = '🎉', description = 'Begin a project' },
  { emoji = '🔒️', description = 'Fix security issues' },
  { emoji = '🔖', description = 'Release / Version tags' },
  { emoji = '🚨', description = 'Fix compiler / linter warnings' },
  { emoji = '🚧', description = 'Work in progress' },
  { emoji = '💚', description = 'Fix CI build' },
  { emoji = '👷', description = 'Add or update CI build system' },
  { emoji = '📦️', description = 'Add or update compiled files or packages' },
  { emoji = '🚚', description = 'Move or rename resources' },
  { emoji = '📄', description = 'Add or update license' },
  { emoji = '💥', description = 'Introduce breaking changes' },
  { emoji = '🏷️', description = 'Add or update types' },
  { emoji = '🌐', description = 'Internationalization and localization' },
  { emoji = '✏️', description = 'Fix typos' },
  { emoji = '⏪️', description = 'Revert changes' },
  { emoji = '🔀', description = 'Merge branches' },
  { emoji = '👽️', description = 'Update code due to external API changes' },
  { emoji = '🍱', description = 'Add or update assets' },
  { emoji = '♿️', description = 'Improve accessibility' },
  { emoji = '💡', description = 'Add or update comments in source code' },
  { emoji = '💬', description = 'Add or update text and literals' },
  { emoji = '🗃️', description = 'Perform database related changes' },
  { emoji = '🔊', description = 'Add or update logs' },
  { emoji = '🔇', description = 'Remove logs' },
  { emoji = '🚸', description = 'Improve user experience / usability' },
  { emoji = '🏗️', description = 'Make architectural changes' },
  { emoji = '📱', description = 'Work on responsive design' },
  { emoji = '🙈', description = 'Add or update a .gitignore file' },
  { emoji = '🩹', description = 'Simple fix for a non-critical issue' },
  { emoji = '⚰️', description = 'Remove dead code' },
  { emoji = '🧪', description = 'Add a failing test' },
  { emoji = '🚩', description = 'Add, update, or remove feature flags' },
  { emoji = '🗑️', description = 'Deprecate code that needs to be cleaned up' },
  { emoji = '🛂', description = 'Authorization, roles and permissions' },
  { emoji = '🧱', description = 'Infrastructure related changes' },
  { emoji = '🥅', description = 'Catch errors' },
  { emoji = '👔', description = 'Add or update business logic' },
}

local function run_commit(type_choice, emoji, scope, msg)
  local subject
  if scope and scope ~= '' then
    subject = string.format('%s(%s): %s %s', type_choice.value, scope, emoji, msg)
  else
    subject = string.format('%s: %s %s', type_choice.value, emoji, msg)
  end
  local output = vim.fn.system({ 'git', 'commit', '-m', subject })
  if vim.v.shell_error ~= 0 then
    vim.notify('Commit failed:\n' .. output, vim.log.levels.ERROR)
  else
    vim.notify('Committed: ' .. subject, vim.log.levels.INFO)
  end
end

function M.create_conventional_commit()
  vim.ui.select(cc_types, {
    prompt = 'Conventional Commit Type:',
    format_item = function(item)
      return string.format('%-10s %s', item.value, item.description)
    end,
  }, function(type_choice)
    if not type_choice then
      return
    end
    vim.ui.select(gitmojis, {
      prompt = 'Gitmoji:',
      format_item = function(item)
        return item.emoji .. '  ' .. item.description
      end,
    }, function(gm)
      if not gm then
        return
      end
      vim.ui.input({ prompt = 'Scope (optional): ' }, function(scope)
        vim.ui.input({ prompt = 'Commit message: ' }, function(msg)
          if not msg or msg == '' then
            return
          end
          run_commit(type_choice, gm.emoji, scope, msg)
        end)
      end)
    end)
  end)
end

return M
