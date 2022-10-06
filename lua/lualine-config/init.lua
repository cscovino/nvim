local custom_gruvbox = require('lualine.themes.gruvbox')

require('lualine').setup({
  options = {
    theme = custom_gruvbox,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
})
