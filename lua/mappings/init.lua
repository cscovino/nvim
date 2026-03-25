vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set

-- General mappings
map('n', '<leader>w', '<Cmd>w<CR>', { desc = 'Save' })
map('n', '<leader>W', '<Cmd>wq<CR>', { desc = 'Save and quit' })
map('n', '<leader>q', '<Cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>Q', '<Cmd>q!<CR>', { desc = 'Force quit' })
local term_bufs = {}
local last_term_buf = nil

local function create_terminal()
  vim.cmd('enew')
  vim.cmd('terminal')
  local buf = vim.api.nvim_get_current_buf()
  table.insert(term_bufs, buf)
  last_term_buf = buf
end

local function clean_term_bufs()
  term_bufs = vim.tbl_filter(vim.api.nvim_buf_is_valid, term_bufs)
  if last_term_buf and not vim.api.nvim_buf_is_valid(last_term_buf) then
    last_term_buf = term_bufs[#term_bufs]
  end
end

map('n', '<leader>tt', function()
  clean_term_bufs()
  if last_term_buf then
    if vim.api.nvim_get_current_buf() == last_term_buf then
      vim.cmd('BufferPrevious')
    else
      vim.api.nvim_set_current_buf(last_term_buf)
    end
  else
    create_terminal()
  end
end, { desc = 'Toggle terminal' })

map('n', '<leader>tn', function()
  create_terminal()
end, { desc = 'New terminal' })
map('n', '<leader>cl', '<Cmd>noh<CR>', { desc = 'Clear highlights' })
map('n', '<leader>rd', '<Cmd>e!<CR>', { desc = 'Reload file (discard)' })
map('n', '<leader>rf', '<Cmd>e<CR>', { desc = 'Refresh file' })
map('t', '<Esc><Esc>', '<C-\\><C-N>', { desc = 'Exit terminal mode' })

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
