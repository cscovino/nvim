-- The :Profile menu. vim.ui.select is looked up at call time: Snacks replaces it
-- on VeryLazy, and the built-in one is used otherwise.
local profile = require('profile')

local M = {}

local function save(pending, restart)
  local before = profile.saved()
  local err = profile.save(pending)
  if err then
    vim.notify('Profile: could not save: ' .. err, vim.log.levels.WARN)
    return
  end
  local msg = 'Profile saved'
  for _, cat in ipairs(profile.TOGGLEABLE) do
    if before.on[cat] and not pending.on[cat] then
      msg = msg .. '. Run :Lazy clean to remove the plugins of disabled categories'
      break
    end
  end
  if not restart then
    vim.notify(msg .. '. Restart Neovim to apply')
    return
  end
  -- Plain :restart refuses to quit with unsaved changes; its command argument
  -- runs on the new server, so the message shows after the restart (D-12)
  local ok, rerr = pcall(vim.cmd.restart, 'lua vim.notify(' .. vim.inspect(msg) .. ')')
  if not ok then
    vim.notify('Profile: saved, but :restart failed: ' .. tostring(rerr), vim.log.levels.WARN)
  end
end

function M.open(pending)
  pending = pending or profile.saved()
  local modified = false
  for _, cat in ipairs(profile.TOGGLEABLE) do
    if pending.on[cat] ~= profile.PRESETS[pending.preset] then
      modified = true
    end
  end

  -- ui, editor and lsp are always on, so they are not listed (D-16, D-17)
  local items = { { preset = 'full' }, { preset = 'minimal' } }
  for _, cat in ipairs(profile.TOGGLEABLE) do
    table.insert(items, { cat = cat })
  end
  table.insert(items, { save = true, restart = true })
  table.insert(items, { save = true })

  local prompt = 'Profile'
  if profile.env then
    prompt = prompt .. ' (NVIM_PROFILE=' .. profile.env .. ' overrides this session)'
  end

  vim.ui.select(items, {
    prompt = prompt,
    format_item = function(item)
      if item.preset then
        if item.preset ~= pending.preset then
          return '( ) preset: ' .. item.preset
        end
        return '(•) preset: ' .. item.preset .. (modified and ' (modified)' or '')
      elseif item.cat then
        return (pending.on[item.cat] and '[x] ' or '[ ] ') .. item.cat
      end
      return item.restart and 'Save & restart' or 'Save (restart later)'
    end,
  }, function(item)
    -- Esc discards the pending changes quietly (D-13)
    if not item then
      return
    end
    if item.preset then
      -- Picking a preset, even the current one, resets every toggle (D-01)
      pending.preset = item.preset
      for _, cat in ipairs(profile.TOGGLEABLE) do
        pending.on[cat] = profile.PRESETS[item.preset]
      end
      M.open(pending)
    elseif item.cat then
      pending.on[item.cat] = not pending.on[item.cat]
      M.open(pending)
    else
      save(pending, item.restart)
    end
  end)
end

return M
