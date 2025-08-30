local PomoNotifier = require('pomo-config.notifier')

require('pomo').setup({
  update_interval = 1000,
  notifiers = {
    { init = PomoNotifier.new, opts = {} },
  },
  sessions = {
    pomodoro = {
      { name = 'Work', duration = '45m' },
      { name = 'Short Break', duration = '7m' },
      { name = 'Work', duration = '45m' },
      { name = 'Short Break', duration = '7m' },
      { name = 'Work', duration = '45m' },
      { name = 'Long Break', duration = '25m' },
    },
    test = {
      { name = 'Work', duration = '15s' },
      { name = 'Short Break', duration = '5s' },
      { name = 'Work', duration = '15s' },
      { name = 'Short Break', duration = '5s' },
      { name = 'Work', duration = '15s' },
      { name = 'Long Break', duration = '10s' },
    },
  },
})
