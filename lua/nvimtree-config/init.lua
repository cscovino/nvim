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

local function open_nvim_tree()
  -- open the tree
  require('nvim-tree.api').tree.open()
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
