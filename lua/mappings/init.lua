vim.g.mapleader = ' '

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General mappings
map('n', '<leader>w', '<Cmd>w<CR>', opts)
map('n', '<leader>wq', '<Cmd>wq<CR>', opts)
map('n', '<leader>q', '<Cmd>q<CR>', opts)
map('n', '<leader>qu', '<Cmd>q!<CR>', opts)

-- Fugitive mappings
map('n', '<leader>gj', '<Cmd>diffget //3<CR>', opts)
map('n', '<leader>gf', '<Cmd>diffget //2<CR>', opts)
map('n', '<leader>gs', '<Cmd>G<CR>', opts)
map('n', '<leader>gm', '<Cmd>G commit<CR>', opts)
map('n', '<leader>gp', '<Cmd>G push<CR>', opts)
map('n', '<leader>gl', '<Cmd>G pull<CR>', opts)
map('n', '<leader>gst', '<Cmd>G stash<CR>', opts)
map('n', '<leader>gsp', '<Cmd>G stash pop<CR>', opts)

-- Navigation mappings
map('n', '<leader>nt', '<Cmd>NvimTreeToggle<CR>', opts)
map('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', opts)
map('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', opts)
map('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', opts)
map('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', opts)
map('n', '<leader>cs', '<Cmd>Telescope colorscheme<CR>', opts)
map('n', '<leader>ch', '<Cmd>Telescope command_history<CR>', opts)

-- Undotree mappings
map('n', '<leader>ut', '<Cmd>UndotreeShow<CR>', opts)

-- Barbar mappings
map('n', '<leader>,', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<leader>.', '<Cmd>BufferNext<CR>', opts)
map('n', '<leader><', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<leader>>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<leader>0', '<Cmd>BufferLast<CR>', opts)
map('n', '<leader>bp', '<Cmd>BufferPin<CR>', opts)
map('n', '<leader>bc', '<Cmd>BufferClose<CR>', opts)
map('n', '<leader>abc', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', opts)
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
