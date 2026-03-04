vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set

-- General mappings
map('n', '<leader>w', '<Cmd>w<CR>', { desc = 'Save' })
map('n', '<leader>wq', '<Cmd>wq<CR>', { desc = 'Save and quit' })
map('n', '<leader>q', '<Cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>qu', '<Cmd>q!<CR>', { desc = 'Force quit' })
map('n', '<leader>tt', '<Cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle terminal' })
map('n', '<leader>cl', '<Cmd>noh<CR>', { desc = 'Clear highlights' })
map('n', '<leader>rd', '<Cmd>e!<CR>', { desc = 'Reload file (discard)' })
map('n', '<leader>rf', '<Cmd>e<CR>', { desc = 'Refresh file' })
map('t', '<Esc>', '<C-\\><C-N>', { desc = 'Exit terminal mode' })

-- Undotree mappings
map('n', '<leader>ut', '<Cmd>UndotreeShow<CR>', { desc = 'Undotree show' })

-- Code action (built-in LSP)
map('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code action' })
