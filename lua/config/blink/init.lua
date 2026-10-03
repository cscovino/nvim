local opts = {
  keymap = {
    preset = 'enter',
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    menu = { border = 'rounded' },
    accept = { auto_brackets = { enabled = true } },
  },
  signature = { enabled = true, window = { border = 'rounded' } },
  snippets = { preset = 'default' },
  sources = {
    default = { 'lazydev', 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      copilot = {
        name = 'copilot',
        module = 'blink-cmp-copilot',
        score_offset = 100,
        async = true,
      },
    },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

-- The copilot source needs copilot.lua, which only the ai category installs.
if not require('profile').enabled('ai') then
  opts.sources.default = vim.tbl_filter(function(name)
    return name ~= 'copilot'
  end, opts.sources.default)
  opts.sources.providers.copilot = nil
end

return opts
