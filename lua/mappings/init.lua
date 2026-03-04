vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General mappings
map('n', '<leader>w', '<Cmd>w<CR>', opts)
map('n', '<leader>wq', '<Cmd>wq<CR>', opts)
map('n', '<leader>q', '<Cmd>q<CR>', opts)
map('n', '<leader>qu', '<Cmd>q!<CR>', opts)
map('n', '<leader>tt', '<Cmd>tab ter<CR>', opts)
map('n', '<leader>cl', '<Cmd>noh<CR>', opts)
map('n', '<leader>rd', '<Cmd>e!<CR>', opts)
map('n', '<leader>rf', '<Cmd>e<CR>', opts)
map('t', '<Esc>', '<C-\\><C-N>', opts)

-- Undotree mappings
map('n', '<leader>ut', '<Cmd>UndotreeShow<CR>', opts)

-- CodeActionMenu mappings
-- map('n', '<leader>ca', '<Cmd>CodeActionMenu<CR>', opts)
map('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
