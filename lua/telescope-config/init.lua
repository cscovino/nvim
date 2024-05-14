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

telescope.load_extension('fzf')
telescope.load_extension('ui-select')
telescope.load_extension('gitmoji')
telescope.load_extension('conventional_commits')

local function create_conventional_commit(opts)
  opts = opts or {}
  local pickers = require('telescope.pickers')
  local actions_state = require('telescope.actions.state')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values

  local cc_actions = require('telescope._extensions.conventional_commits.actions')
  local cc_types = require('telescope._extensions.conventional_commits.types')
  local frecency = require('telescope._extensions.gitmoji.frecency')

  pickers
    .new(opts, {
      prompt_title = 'Conventional Commits',
      finder = finders.new_table({
        results = cc_types,
        entry_maker = function(cc_entry)
          return {
            value = cc_entry.value,
            display = string.format('%-10s %s', cc_entry.value, cc_entry.description),
            ordinal = cc_entry.value,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(cc_prompt_bufnr, cc_map)
        actions.select_default:replace(function()
          local cc_type = actions_state.get_selected_entry()
          actions.close(cc_prompt_bufnr)
          pickers
            .new(opts, {
              prompt_title = 'Gitmojis',
              finder = finders.new_dynamic({
                fn = function()
                  return frecency:get_sorted_emojis()
                end,
                entry_maker = function(gm_entry)
                  return {
                    value = gm_entry,
                    display = gm_entry.value .. ' ' .. gm_entry.description,
                    ordinal = gm_entry.description,
                  }
                end,
              }),
              sorter = conf.generic_sorter(opts),
              attach_mappings = function(gm_prompt_bufnr, gm_map)
                actions.select_default:replace(function()
                  local gm = actions_state.get_selected_entry()
                  local emoji = gm.value.value
                  actions.close(gm_prompt_bufnr)
                  -- Execute gm action
                  frecency:record(emoji)
                  -- Execute cc action
                  local inputs = {}
                  vim.ui.input({ prompt = 'Is there a scope ? (optional) ' }, function(scope)
                    inputs['scope'] = scope

                    vim.ui.input({ prompt = 'Enter commit message: ' }, function(msg)
                      if not msg then
                        return
                      end

                      inputs['msg'] = emoji .. ' ' .. msg

                      cc_actions.commit(cc_type.value, inputs)
                    end)
                  end)
                end)
                return true
              end,
            })
            :find()
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', 'cc', create_conventional_commit, { desc = 'Create conventional commit' })
