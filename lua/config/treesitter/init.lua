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

local ts = require('nvim-treesitter')
local installed = ts.get_installed()
local missing = vim.tbl_filter(function(lang)
  return not vim.list_contains(installed, lang)
end, parsers)

-- Only probe the tools when something needs building, so a normal start
-- spawns nothing
if #missing > 0 then
  local broken = {}
  -- executable() passes the Mac's broken pnpm shim, and vim.system raises when
  -- the binary is absent, so executable() must come first
  if vim.fn.executable('tree-sitter') == 0 or vim.system({ 'tree-sitter', '--version' }):wait(5000).code ~= 0 then
    table.insert(broken, 'tree-sitter')
  end
  if vim.fn.executable('cc') == 0 then
    table.insert(broken, 'cc')
  end

  if #broken == 0 then
    -- nvim-treesitter's default of up to 100 parallel compiles runs a 4 GB
    -- machine out of memory. Pass nil, never 0, on bigger machines.
    ts.install(parsers, vim.uv.get_total_memory() < 6 * 1024 ^ 3 and { max_jobs = 2 } or nil)
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

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserTreesitterStart', { clear = true }),
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
