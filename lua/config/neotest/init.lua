-- get neotest namespace (api call creates or returns namespace)
local neotest_ns = vim.api.nvim_create_namespace('neotest')
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)
local neotest = require('neotest')
neotest.setup({
  adapters = {
    require('neotest-vitest')({
      -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
      filter_dir = function(name, rel_path, root)
        return name ~= 'node_modules'
      end,
    }),
    require('neotest-jest')({
      jestCommand = 'npm run test',
      jestConfigFile = 'package.json',
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    }),
  },
  -- your neotest config here
  consumers = {
    always_open_output = function(client)
      local async = require('neotest.async')

      client.listeners.results = function(adapter_id, results)
        local file_path = async.fn.expand('%:p')
        local row = async.fn.getpos('.')[2] - 1
        local position = client:get_nearest(file_path, row, {})
        if not position then
          return
        end
        local pos_id = position:data().id
        if not results[pos_id] then
          return
        end
        neotest.output_panel.open({ position_id = pos_id, adapter = adapter_id })
      end
    end,
  },
})
