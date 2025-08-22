require('pomo').setup({
  update_interval = 1000,
  sessions = {
    pomodoro = {
      { name = 'Work', duration = '45m' },
      { name = 'Short Break', duration = '7m' },
      { name = 'Work', duration = '45m' },
      { name = 'Short Break', duration = '7m' },
      { name = 'Work', duration = '45m' },
      { name = 'Long Break', duration = '25m' },
    },
  },
})
