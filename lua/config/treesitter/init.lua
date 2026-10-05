local parsers = {
  'astro',
  'bash',
  'c',
  'cpp',
  'css',
  'cuda',
  'dockerfile',
  'gitignore',
  'glsl',
  'go',
  'html',
  'http',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'scss',
  'typescript',
  'tsx',
  'vim',
  'vimdoc',
  'yaml',
}

-- Registered before the install gate, so a failure there can't take highlighting down
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserTreesitterStart', { clear = true }),
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

local M = { parsers = parsers }
local ts = require('nvim-treesitter')
local installed = ts.get_installed()
local missing = vim.tbl_filter(function(lang)
  return not vim.list_contains(installed, lang)
end, parsers)

-- Only probe the tools when something needs building, so a normal start
-- spawns nothing
if #missing > 0 then
  local broken = {}
  -- executable() passes the Mac's broken pnpm shim. vim.system raises when the
  -- binary is absent or can't be exec'd (bad shebang, wrong arch), so
  -- executable() comes first and the spawn is pcall'd
  local ok, works = pcall(function()
    return vim.fn.executable('tree-sitter') == 1 and vim.system({ 'tree-sitter', '--version' }):wait(5000).code == 0
  end)
  if not (ok and works) then
    table.insert(broken, 'tree-sitter')
  end
  if vim.fn.executable('cc') == 0 then
    table.insert(broken, 'cc')
  end

  if #broken == 0 then
    -- nvim-treesitter's default of up to 100 parallel compiles runs a 4 GB
    -- machine out of memory. Pass nil, never 0, on bigger machines.
    M.task = ts.install(parsers, vim.uv.get_total_memory() < 6 * 1024 ^ 3 and { max_jobs = 2 } or nil)
  else
    -- May run before Snacks replaces vim.notify
    vim.schedule(function()
      vim.notify(
        'Treesitter: not installing '
          .. table.concat(missing, ', ')
          .. ', missing or broken: '
          .. table.concat(broken, ', '),
        vim.log.levels.WARN
      )
    end)
  end
end
-- install.sh waits on this task so a headless run doesn't exit mid-build; the plugin spec ignores it
return M
