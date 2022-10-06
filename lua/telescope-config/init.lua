local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    mappings = {
      n = {
        ['<C-t>'] = actions.git_track_branch,
        ['<C-r>'] = actions.git_rebase_branch,
        ['<C-b>'] = actions.git_create_branch,
        ['<C-s>'] = actions.git_switch_branch,
        ['<C-d>'] = actions.git_delete_branch,
        ['<C-e>'] = actions.git_merge_branch,
      },
      i = {
        ['<C-t>'] = actions.git_track_branch,
        ['<C-r>'] = actions.git_rebase_branch,
        ['<C-b>'] = actions.git_create_branch,
        ['<C-s>'] = actions.git_switch_branch,
        ['<C-d>'] = actions.git_delete_branch,
        ['<C-e>'] = actions.git_merge_branch,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
    },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
