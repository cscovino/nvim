local PomoNotifier = {}
local util = require('pomo.util')
local Popup = require('nui.popup')
local notifier = require('utils.notifier')

PomoNotifier.new = function(timer, opts)
  local self = setmetatable({}, { __index = PomoNotifier })
  local popup = Popup({
    enter = false,
    focusable = false,
    border = {
      style = 'rounded',
      text = {
        top = ' Pomodoro Break  ',
        top_align = 'center',
      },
    },
    position = '50%',
    size = {
      width = '20%',
      height = '20%',
    },
  })
  self.popup = popup
  self.timer = timer
  self.hidden = false
  self.opts = opts -- not used
  return self
end

PomoNotifier.start = function(self)
  local message = string.format('%s started for %s', self.timer.name, util.format_time(self.timer.time_limit))
  if string.match(self.timer.name, 'Break') then
    self.popup:mount()
    notifier.notify({ title = 'Pomodoro BREAK! 🍅', message = message, sound = 'Sosumi' })
  else
    notifier.notify({ title = 'Pomodoro WORK 🙁', message = message, sound = 'Ping' })
    vim.notify(string.format('Starting %s, for %ds', self.timer.name, self.timer.time_limit))
  end
end

PomoNotifier.tick = function(self, time_left)
  if not self.hidden and string.match(self.timer.name, 'Break') then
    vim.api.nvim_buf_set_lines(
      self.popup.bufnr,
      0,
      1,
      false,
      { string.format('🍅 %s, %s remaining', self.timer.name, util.format_time(time_left)) }
    )
  end
end

PomoNotifier.done = function(self)
  if string.match(self.timer.name, 'Break') then
    self.popup:unmount()
  else
    vim.notify(string.format('Timer %s, complete', self.timer.name))
  end
end

PomoNotifier.stop = function(self)
  if string.match(self.timer.name, 'Break') then
    self.popup:unmount()
  end
end

PomoNotifier.show = function(self)
  self.hidden = false
end

PomoNotifier.hide = function(self)
  self.hidden = true
end

return PomoNotifier
