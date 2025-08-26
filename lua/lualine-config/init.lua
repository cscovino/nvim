require('lualine').setup({
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        symbols = { error = '', warn = ' ', hint = '⚡', info = ' ' },
      },
    },
    lualine_x = {
      function()
        local ok, pomo = pcall(require, 'pomo')
        if not ok then
          return ''
        end

        local timer = pomo.get_first_to_finish()
        if timer == nil then
          return ''
        end

        return ' ' .. tostring(timer)
      end,
      'encoding',
      'fileformat',
      'filetype',
    },
  },
})
