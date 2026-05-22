vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set

-- General mappings
map('n', '<leader>w', '<Cmd>w<CR>', { desc = 'Save' })
map('n', '<leader>W', '<Cmd>wq<CR>', { desc = 'Save and quit' })
map('n', '<leader>q', '<Cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', '<Cmd>q!<CR>', { desc = 'Force quit' })
map('n', '<leader>cl', '<Cmd>noh<CR>', { desc = 'Clear highlights' })
map('n', '<leader>rd', '<Cmd>e!<CR>', { desc = 'Reload file (discard)' })
map('n', '<leader>rf', '<Cmd>e<CR>', { desc = 'Refresh file' })
map('t', '<C-x>', '<C-\\><C-N>', { desc = 'Exit terminal mode' })

map('n', '<leader>bn', function()
  vim.ui.input({ prompt = 'Buffer name: ' }, function(name)
    if name and name ~= '' then
      vim.api.nvim_buf_set_name(0, name)
      vim.cmd('redrawtabline')
    end
  end)
end, { desc = 'Rename buffer' })

-- Undotree mappings
map('n', '<leader>ut', '<Cmd>UndotreeShow<CR>', { desc = 'Undotree show' })

-- Code action (built-in LSP)
map('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code action' })
