-- Disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.filetype.add({
  extension = {
    vert = 'glsl',
    tesc = 'glsl',
    tese = 'glsl',
    frag = 'glsl',
    geom = 'glsl',
    comp = 'glsl',
  },
})

local set = vim.opt

set.winborder = 'rounded'
set.background = 'dark'
set.clipboard = 'unnamedplus'
set.cmdheight = 1
set.cursorline = true
set.cursorlineopt = 'both'
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
set.scrolloff = 10
set.shiftwidth = 2
set.showcmd = true
set.showmatch = true
set.smarttab = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.tabstop = 2
set.termguicolors = true
set.undodir = vim.fn.expand('~/.config/nvim/undodir')
set.undofile = true
set.signcolumn = 'yes'
set.wrap = false

set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldlevelstart = 99

