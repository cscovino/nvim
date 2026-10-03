local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local profile = require('profile')

-- Disabled categories are never imported, so lazy never clones them
local spec = {}
for _, cat in ipairs(profile.CATEGORIES) do
  if profile.enabled(cat) then
    table.insert(spec, { import = 'plugins.' .. cat })
  end
end

local lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json'
if not profile.is_full() then
  -- lazy rewrites its lockfile with only the current spec's plugins, so a
  -- reduced profile works on a copy that is re-made every start
  local state = vim.fn.stdpath('state')
  local copy = state .. '/lazy-lock.json'
  pcall(vim.fn.mkdir, state, 'p')
  local ok, err = vim.uv.fs_copyfile(lockfile, copy)
  if not ok then
    vim.schedule(function()
      vim.notify('Profile: could not copy lazy-lock.json, plugins may be unpinned: ' .. err, vim.log.levels.WARN)
    end)
  end
  -- Never fall back to the repo lockfile, or a reduced profile would strip its pins
  lockfile = copy
end

require('lazy').setup({
  spec = spec,
  lockfile = lockfile,
  ui = {
    border = 'rounded',
  },
})
