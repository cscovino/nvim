vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Diagnostic float' })
vim.keymap.set('n', '<leader>pd', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Prev diagnostic' })
vim.keymap.set('n', '<leader>nd', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>lc', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('gr', function()
      -- Snacks comes from the ui category; fall back to the built-in list if it failed to load
      if _G.Snacks then
        Snacks.picker.lsp_references()
      else
        vim.lsp.buf.references()
      end
    end, 'Go to references')
    map('gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('K', vim.lsp.buf.hover, 'Hover documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    map('<leader>D', vim.lsp.buf.type_definition, 'Type definition')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('<leader>f', vim.lsp.buf.format, 'Format buffer')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'List workspace folders')

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight') then
      local hl_group = vim.api.nvim_create_augroup('UserLspHighlight', { clear = false })
      vim.api.nvim_clear_autocmds({ group = hl_group, buffer = bufnr })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  flags = { debounce_text_changes = 150 },
})

vim.lsp.config('glsl_analyzer', {
  filetypes = { 'glsl' },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'Snacks' } },
      telemetry = { enable = false },
    },
  },
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
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

-- These lspconfig servers have function cmds (a project node_modules lookup),
-- so there is no cmd[1] to check
local node_bins = {
  astro = 'astro-ls',
  cssls = 'vscode-css-language-server',
  eslint = 'vscode-eslint-language-server',
  html = 'vscode-html-language-server',
  jsonls = 'vscode-json-language-server',
}

-- A missing function-cmd server WARNs on every buffer, so skip servers whose
-- binary is missing. A name with no config, or with a function cmd not in
-- node_bins, stays enabled: executable(nil) and indexing a nil config both
-- raise and would stop every server.
vim.lsp.enable(vim.tbl_filter(function(name)
  local cmd = (vim.lsp.config[name] or {}).cmd
  local bin = type(cmd) == 'table' and cmd[1] or node_bins[name]
  return not bin or vim.fn.executable(bin) == 1
end, {
  'astro',
  'clangd',
  'cssls',
  'dockerls',
  'eslint',
  'glsl_analyzer',
  'html',
  'jsonls',
  'lua_ls',
  'pyright',
  'vtsls',
}))
