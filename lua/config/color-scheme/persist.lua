local state_file = vim.fn.stdpath('state') .. '/colorscheme'
local default = 'gruvbox'

local function read_saved()
  local f = io.open(state_file, 'r')
  if not f then
    return nil
  end
  local name = f:read('*l')
  f:close()
  if name and name ~= '' then
    return name
  end
  return nil
end

local function save(name)
  local f = io.open(state_file, 'w')
  if f then
    f:write(name)
    f:close()
  end
end

local function apply_highlight_overrides()
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#504945' })
  vim.api.nvim_set_hl(0, 'SnacksPickerListCursorLine', { link = 'PmenuSel' })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('UserColorSchemePersist', { clear = true }),
  callback = function(args)
    if args.match and args.match ~= '' then
      save(args.match)
    end
    apply_highlight_overrides()
  end,
})

vim.o.background = 'dark'
local saved = read_saved() or default
local ok = pcall(vim.cmd.colorscheme, saved)
if not ok then
  pcall(vim.cmd.colorscheme, default)
end
