local M = {}

-- Alphabetical, the order the old `import = 'plugins'` directory import used,
-- so lazy merges plugin fragments in the same order.
M.CATEGORIES = { 'ai', 'debug', 'editor', 'extras', 'http', 'lsp', 'testing', 'ui' }
-- ui, editor and lsp are always on
M.TOGGLEABLE = { 'ai', 'debug', 'extras', 'http', 'testing' }
-- The value each preset gives every toggleable category
M.PRESETS = { full = true, minimal = false }
M.file = vim.fn.stdpath('state') .. '/profile'

-- Runs before lazy.setup, so Snacks has not replaced vim.notify yet
local function warn(msg)
  vim.schedule(function()
    vim.notify('Profile: ' .. msg, vim.log.levels.WARN)
  end)
end

local function build(preset, categories)
  categories = type(categories) == 'table' and categories or {}
  local on = {}
  for _, cat in ipairs(M.TOGGLEABLE) do
    local v = categories[cat]
    -- Non-boolean values fall back to the preset, like unknown keys (D-06)
    if type(v) == 'boolean' then
      on[cat] = v
    else
      on[cat] = M.PRESETS[preset]
    end
  end
  return { preset = preset, on = on }
end

local function read()
  local f = io.open(M.file, 'r')
  if not f then
    return build('full')
  end
  local text = f:read('*a')
  f:close()
  local ok, data = pcall(vim.json.decode, text or '', { luanil = { object = true, array = true } })
  if not ok or type(data) ~= 'table' then
    warn(M.file .. ' is not valid JSON, loading full')
    return build('full')
  end
  local preset = data.preset or 'full'
  if M.PRESETS[preset] == nil then
    warn('unknown preset ' .. vim.inspect(data.preset) .. ' in ' .. M.file .. ', loading full')
    return build('full')
  end
  return build(preset, data.categories)
end

local saved = read()
local active = saved

local env = vim.env.NVIM_PROFILE
if env and env ~= '' then
  if M.PRESETS[env] ~= nil then
    -- The env var means "run exactly this preset": saved deltas are dropped (D-09)
    M.env = env
    active = build(env)
  else
    warn('unknown NVIM_PROFILE=' .. env .. ', using ' .. M.file)
  end
end

function M.enabled(cat)
  -- ui, editor and lsp are not in `on`, so they are always enabled
  return active.on[cat] ~= false
end

-- Full means all toggleable categories on, whatever the preset name (D-03)
function M.is_full()
  for _, cat in ipairs(M.TOGGLEABLE) do
    if not active.on[cat] then
      return false
    end
  end
  return true
end

-- The saved file's state, not the NVIM_PROFILE override: what :Profile shows and edits (D-11)
function M.saved()
  return vim.deepcopy(saved)
end

-- Writes only the toggles that differ from the preset (D-04). Returns an error string on failure.
function M.save(state)
  local categories = vim.empty_dict()
  for _, cat in ipairs(M.TOGGLEABLE) do
    if state.on[cat] ~= M.PRESETS[state.preset] then
      categories[cat] = state.on[cat]
    end
  end
  local json = vim.json.encode({ preset = state.preset, categories = categories }, { sort_keys = true })
  -- io.open's error already starts with the path
  local f, err = io.open(M.file, 'w')
  if f then
    local _, werr = f:write(json, '\n')
    local _, cerr = f:close()
    if werr or cerr then
      err = M.file .. ': ' .. (werr or cerr)
    end
  end
  if err then
    return err
  end
  saved = build(state.preset, categories)
end

vim.api.nvim_create_user_command('Profile', function()
  require('profile.menu').open()
end, { desc = 'Pick the plugin categories to load (applies after a restart)' })

return M
