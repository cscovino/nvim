local spectre = require('spectre')

spectre.setup({
  mapping = {
    ['send_to_qf'] = {
      map = '<leader>Q',
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = 'send all items to quickfix',
    },
  },
})

vim.keymap.set('n', '<leader>rp', spectre.toggle, { desc = 'Toggle Spectre' })
