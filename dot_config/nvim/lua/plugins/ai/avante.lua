return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- this file can contain specific instructions for your project
      instructions_file = 'avante.md',
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
      },
    },
    build = 'make',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
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
            -- required for Windows users
            use_absolute_path = true,
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
  },
}
