local dap = require('dap')
local dapui = require('dapui')

-- UI setup
dapui.setup()

-- Auto open/close UI on debug sessions
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- JS/TS debug adapters (vscode-js-debug)
local js_debug_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug'

for _, adapter in ipairs({ 'pwa-node', 'pwa-chrome' }) do
  dap.adapters[adapter] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = { js_debug_path .. '/out/src/dapDebugServer.js', '${port}' },
    },
  }
end

-- Configurations for JS/TS filetypes
local js_based_languages = {
  'javascript',
  'typescript',
  'javascriptreact',
  'typescriptreact',
}

for _, language in ipairs(js_based_languages) do
  dap.configurations[language] = {
    -- Node.js: attach to running process
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to Node process',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
    -- Node.js: launch current file
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch current file (Node)',
      program = '${file}',
      cwd = '${workspaceFolder}',
    },
    -- Next.js: debug server-side
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Next.js: debug server-side',
      runtimeExecutable = 'npx',
      runtimeArgs = { 'next', 'dev', '--webpack' },
      autoAttachChildProcesses = true,
      skipFiles = { '<node_internals>/**' },
      console = 'integratedTerminal',
      cwd = '${workspaceFolder}',
    },
    -- Chrome/Arc: launch
    {
      type = 'pwa-chrome',
      request = 'launch',
      name = 'Launch Chrome (http://localhost:3000)',
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({ prompt = 'URL: ', default = 'http://localhost:3000' }, function(url)
            if url == nil or url == '' then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = '${workspaceFolder}',
      sourceMaps = true,
    },
  }
end

-- Signs
vim.fn.sign_define('DapBreakpoint', { text = '◉', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapLogPoint', { text = '◎', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'DapStoppedLine' })
vim.fn.sign_define('DapBreakpointRejected', { text = '✗', texthl = 'DiagnosticError' })
