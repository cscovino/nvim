local lint = require('lint')

lint.linters_by_ft = {
  -- go = { 'golangcilint' },
  yaml = { 'yamllint' },
  glsl = { 'glslc' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
  callback = function()
    -- Skip linters that aren't installed instead of an ENOENT ERROR on every save
    lint.try_lint(nil, {
      filter = function(linter)
        return vim.fn.executable(linter.cmd) == 1
      end,
    })
  end,
})
