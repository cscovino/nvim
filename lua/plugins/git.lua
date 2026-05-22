return {
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>dv', '<Cmd>DiffviewOpen<CR>', desc = 'Diffview open' },
      { '<leader>dh', '<Cmd>DiffviewFileHistory %<CR>', desc = 'Diffview file history' },
    },
    opts = {},
  },
}
