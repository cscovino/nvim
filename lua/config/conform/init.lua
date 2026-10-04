require('conform').setup({
  -- A missing formatter is logged (:ConformInfo) and LSP formatting is used instead
  notify_no_formatters = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    css = { 'prettierd' },
    scss = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    yaml = { 'prettierd' },
    markdown = { 'prettierd' },
    -- astro = { 'prettierd' },
    -- go = { 'goimports_reviser', 'golines' },
  },
  format_on_save = {
    timeout_ms = 3000,
    lsp_fallback = true,
  },
})
