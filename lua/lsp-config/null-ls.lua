local null_ls = require('null-ls')
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
-- local diagnostics = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion
local augroup_formatting = vim.api.nvim_create_augroup('LspFormatting', {})
local sources = {
  code_actions.eslint_d,
  formatting.eslint_d,
  formatting.autopep8,
  formatting.stylua,
  formatting.prettier_d_slim,
}

null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({ group = augroup_formatting, buffer = bufnr })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup_formatting,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
