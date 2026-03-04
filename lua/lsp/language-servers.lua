vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
vim.keymap.set('n', '<leader>pd', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Prev diagnostic' })
vim.keymap.set('n', '<leader>nd', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>lc', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })

local on_attach = function(_, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Only custom keymaps here; gd, gD, K, gi, gr, <C-k> are Neovim 0.11 defaults
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = 'Add workspace folder' })
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = 'Remove workspace folder' })
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = 'List workspace folders' })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type definition' })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format buffer' })
end

local lspconfig = vim.lsp.config
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_flags = { debounce_text_changes = 150 }
local servers = {
  -- 'astro',
  'cssls',
  'dockerls',
  'glsl_analyzer',
  -- 'golangci_lint_ls',
  -- 'gopls',
  'html',
  'jsonls',
  'lua_ls',
  'pyright',
  'ts_ls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp] = {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls = {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '⚡',
    },
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
  },
  severity_sort = {
    [vim.diagnostic.severity.ERROR] = 1,
    [vim.diagnostic.severity.WARN] = 2,
    [vim.diagnostic.severity.INFO] = 3,
    [vim.diagnostic.severity.HINT] = 4,
  },
})

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end
