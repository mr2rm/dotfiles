return { -- MCP client to integrate MCP servers
  'ravitemer/mcphub.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- Installs `mcp-hub` node binary globally
  build = 'npm install -g mcp-hub@latest',
  opts = {
    ui = {
      window = {
        border = 'rounded',
      },
    },
    extensions = {
      avante = {
        -- make /slash commands from MCP server prompts
        make_slash_commands = true,
      },
    },
  },
}
