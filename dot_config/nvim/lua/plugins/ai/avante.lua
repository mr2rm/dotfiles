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
    provider = 'copilot-default',
    providers = {
      copilot = {
        --[[ NOTE: Defaulted to `gpt-5-mini` as the best choice for everyday usage.

          Other non-premium models (`gpt-4o` and `gpt-4.1`) can also be used as default.
          Premium models are subject to monthly premium quota limits, so you should
          switch to them manually only for specific tasks.

          https://docs.github.com/en/copilot/reference/ai-models/supported-models
        ]]
        model = 'gpt-5-mini',
      },

      -- NOTE: Custom Copilot providers
      ['copilot-default'] = { -- chat, code explanation, edits, everyday debugging, general coding, writing
        __inherited_from = 'copilot',
        model = 'gpt-5-mini', -- reasoning, 400K context, 128K output
        display_name = 'copilot-free/Default (gpt-5-mini)',
        context_window = 128000,
        timeout = 45000,
      },
      ['copilot-general'] = { -- second opinion, general purpose, large-context fallback, compare with reasoning-heavy answers
        __inherited_from = 'copilot',
        model = 'gpt-4.1', -- non-reasoning, low-latency, 1M context, 32K output
        display_name = 'copilot-free/General (gpt-4.1)',
        context_window = 128000,
      },
      ['copilot-default'] = { -- chat, code explanation, edits, everyday debugging, general coding, writing
        __inherited_from = 'copilot',
        model = 'gpt-5-mini', -- reasoning, 400K context, 128K output
        display_name = 'copilot-free/Default (gpt-5-mini)',
        context_window = 128000,
        timeout = 45000,
      },
      ['copilot-explore'] = { -- repo exploration, agentic workflows, codebase search, file discovery
        __inherited_from = 'copilot',
        model = 'gpt-5.4-mini', -- reasoning, 400K context, 128K output
        display_name = 'copilot-premium/Explore (gpt-5.4-mini) [x0.33]',
        context_window = 128000,
        timeout = 45000,
      },
      ['copilot-build'] = { -- implementing features, writing tests, debugging, refactors, code reviews, multi-file changes
        __inherited_from = 'copilot',
        model = 'gpt-5.3-codex', -- reasoning, 400K context, 128K output
        display_name = 'copilot-premium/Build (gpt-5.3-codex) [x1]',
        context_window = 128000,
        timeout = 60000,
      },
      ['copilot-reason'] = { -- hard debugging, design tradeoffs, architecture planning, cross-file root-cause analysis
        __inherited_from = 'copilot',
        model = 'claude-sonnet-4.6', -- reasoning, 1M context, 128K output
        display_name = 'copilot-premium/Reason (claude-sonnet-4.6) [x1]',
        context_window = 128000,
        timeout = 75000,
      },
      ['copilot-strong'] = { -- toughest analysis, highest-capability escalation path, last resort when stuck
        __inherited_from = 'copilot',
        model = 'claude-opus-4.6', -- reasoning, 1M context, 128K output
        display_name = 'copilot-premium/Strong (claude-opus-4.6) [x3]',
        context_window = 128000,
        timeout = 90000,
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
    -- -- TODO: Disable built-in tools to rely on Neovim server and preventing duplication
    -- -- https://github.com/yetone/avante.nvim/blob/main/lua/avante/llm_tools/init.lua
    -- disabled_tools = {
    --   'dispatch_agent',
    --   'glob',
    --   'run_python',
    --   'git_diff',
    --   'git_commit',
    --   'ls',
    --   'grep',
    --   'delete_tool_use_messages',
    --   'read_todos',
    --   'write_todos',
    --   'read_file_toplevel_symbols',
    --   'str_replace',
    --   'view',
    --   'write_to_file',
    --   'insert',
    --   'undo_edit',
    --   'move_path',
    --   'copy_path',
    --   'delete_path',
    --   'create_dir',
    --   'think',
    --   'get_diagnostics',
    --   'bash',
    --   'attempt_completion',
    --   'web_search',
    --   'fetch',
    --   'read_definitions',
    --   'add_file_to_context',
    --   'remove_file_from_context',
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
