require('telescope').setup({
  defaults = {
    mappings = {
      ['<C-t>'] = 'git_track_branch',
      ['<C-r>'] = 'git_rebase_branch',
      ['<C-b>'] = 'git_create_branch',
      ['<C-s>'] = 'git_switch_branch',
      ['<C-d>'] = 'git_delete_branch',
      ['<C-e>'] = 'git_merge_branch',
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
