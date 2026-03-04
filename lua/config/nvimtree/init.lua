require('nvim-tree').setup({
  view = {
    float = {
      enable = true,
    },
  },
  renderer = {
    indent_markers = { enable = true },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  diagnostics = {
    enable = true,
  },
})
