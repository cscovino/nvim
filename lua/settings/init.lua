local set = vim.opt

vim.notify = require('notify')

set.background = 'dark'
set.clipboard = 'unnamed'
set.cmdheight = 2
set.cursorline = true
set.encoding = 'utf-8'
set.expandtab = true
set.hlsearch = true
set.hidden = true
set.ignorecase = true
set.incsearch = true
set.laststatus = 2
set.mouse = 'a'
set.number = true
set.numberwidth = 1
set.relativenumber = true
set.ruler = true
set.scrolloff = 5
set.shiftwidth = 2
set.showcmd = true
set.showmatch = true
set.smarttab = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.tabstop = 2
set.termguicolors = true
set.undodir = 'undodir'
set.undofile = true
set.wrap = false

vim.cmd('syntax enable')
