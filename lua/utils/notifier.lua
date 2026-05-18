local M = {}

local function shell_escape(s)
  return "'" .. tostring(s or ''):gsub("'", "'\\''") .. "'"
end

---Send a macOS notification via terminal-notifier.
---No-op when terminal-notifier is not installed.
---@param opts { title: string, message: string, sound?: string, activate?: string }
function M.notify(opts)
  if vim.fn.executable('terminal-notifier') == 0 then
    return
  end
  local cmd = string.format(
    'terminal-notifier -title %s -message %s -sound %s',
    shell_escape(opts.title),
    shell_escape(opts.message),
    shell_escape(opts.sound or 'Glass')
  )
  if opts.activate then
    cmd = cmd .. ' -activate ' .. shell_escape(opts.activate)
  end
  os.execute(cmd .. ' &')
end

return M
