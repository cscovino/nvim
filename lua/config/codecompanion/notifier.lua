local notifier = require('utils.notifier')

local M = {}

local function last_llm_text(bufnr)
  local ok, chat = pcall(function()
    return require('codecompanion').buf_get_chat(bufnr)
  end)
  if not ok or not chat or not chat.messages then
    return nil
  end
  for i = #chat.messages, 1, -1 do
    local msg = chat.messages[i]
    if msg and msg.role == 'llm' and msg.content then
      local text = type(msg.content) == 'string' and msg.content
        or (type(msg.content) == 'table' and msg.content[1] and msg.content[1].text or '')
      if text and text ~= '' then
        return text
      end
    end
  end
  return nil
end

function M.setup(opts)
  opts = opts or {}
  local done_debounce_ms = opts.done_debounce_ms or 500
  local preview_max = opts.preview_max or 140

  vim.g.nvim_focused = true
  local focus_group = vim.api.nvim_create_augroup('codecompanion_focus', { clear = true })
  vim.api.nvim_create_autocmd('FocusGained', {
    group = focus_group,
    callback = function()
      vim.g.nvim_focused = true
    end,
  })
  vim.api.nvim_create_autocmd('FocusLost', {
    group = focus_group,
    callback = function()
      vim.g.nvim_focused = false
    end,
  })

  local done_timer = assert(vim.uv.new_timer())
  local group = vim.api.nvim_create_augroup('codecompanion_notify', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatDone',
    group = group,
    callback = function(args)
      local bufnr = args.data and args.data.bufnr
      done_timer:stop()
      done_timer:start(done_debounce_ms, 0, function()
        vim.schedule(function()
          if vim.g.nvim_focused then
            return
          end
          local text = last_llm_text(bufnr)
          local preview = text and vim.trim(text):sub(1, preview_max) or 'Response ready'
          notifier.notify({ title = 'CodeCompanion 🤖', message = preview, sound = 'Glass' })
        end)
      end)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionToolApprovalRequested',
    group = group,
    callback = function(args)
      if vim.g.nvim_focused then
        return
      end
      local tool = args.data and args.data.name or 'tool'
      notifier.notify({
        title = 'CodeCompanion ⚠️',
        message = string.format('Approval requested: %s', tool),
        sound = 'Ping',
      })
    end,
  })
end

return M
