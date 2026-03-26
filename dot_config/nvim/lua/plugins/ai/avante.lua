return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  build = 'make',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'ravitemer/mcphub.nvim',
    -- NOTE: Optional dependencies
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'stevearc/dressing.nvim', -- for input provider dressing
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    { -- Support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          verbose = false,
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true, -- required for Windows users
        },
      },
    },
    { -- NOTE: Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    instructions_file = 'avante.md', -- contains specific instructions for your project
    provider = 'copilot',
    providers = {
      copilot = {
        -- NOTE: Defaulted to `gpt-4.1` as the best choice for everyday.
        -- Other non-premium Copilot models (`gpt-4o` and `gpt-5-mini`) can also be
        -- used as defaults. Premium models, such as `claude-opus-4.6`, are subject to
        -- Copilot monthly premium quota limits, so you should switch to them manually
        -- only for specific tasks.
        -- https://docs.github.com/en/copilot/reference/ai-models/supported-models
        model = 'gpt-4.1',
      },
    },
    windows = {
      width = 40,
    },
    behaviour = {
      auto_approve_tool_permissions = false,
      confirmation_ui_style = 'popup',
    },
    system_prompt = function() -- ensures LLM always has latest MCP server state
      -- evaluated for every message, even in existing chats
      local hub = require('mcphub').get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ''
    end,
    custom_tools = function() -- prevents requiring MCPHub before it's loaded
      return {
        require('mcphub.extensions.avante').mcp_tool(),
      }
    end,
    rules = {
      project_dir = '.avante/rules', -- Relative to project root or absolute path
      global_dir = '~/.config/avante/rules', -- Absolute path
    },
    -- other configurations
    selector = {
      exclude_auto_select = { 'NvimTree' },
    },
    -- TODO: Disable built-in tools to rely on Neovim server and preventing duplication
    -- https://github.com/yetone/avante.nvim/blob/main/lua/avante/llm_tools/init.lua
    -- disabled_tools = {
    --   'bash',
    --   'ls',
    --   'glob',
    --   'view',
    --   'edit_file',
    --   'replace_in_file',
    --   'str_replace',
    --   'insert',
    --   'create',
    --   'write_to_file',
    --   'move_path',
    --   'copy_path',
    --   'delete_path',
    --   'create_dir',
    -- },
  },
  keys = {
    {
      '<leader>a+',
      function()
        require('avante.extensions.nvim_tree').add_file()
      end,
      desc = 'Select file in NvimTree',
      ft = 'NvimTree',
    },
    {
      '<leader>a-',
      function()
        require('avante.extensions.nvim_tree').remove_file()
      end,
      desc = 'Deselect file in NvimTree',
      ft = 'NvimTree',
    },
  },
}
