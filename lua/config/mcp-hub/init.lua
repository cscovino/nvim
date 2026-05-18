local mcp = require('mcphub')

mcp.setup({
  extensions = {
    codecompanion = {
      make_tools = true,
      show_server_tools_in_chat = true,
      add_mcp_prefix_to_tool_names = false,
      make_vars = true,
      make_slash_commands = true,
      show_result_in_chat = true,
    },
  },
})
