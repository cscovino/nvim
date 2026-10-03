return {
  {
    'epwalsh/pomo.nvim',
    version = '*',
    lazy = true,
    cmd = { 'TimerStart', 'TimerRepeat', 'TimerSession' },
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('config.pomo')
    end,
  },
  { 'ThePrimeagen/vim-be-good', cmd = 'VimBeGood' },
}
