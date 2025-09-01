return {
  { -- File explorer
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- Optional image support in preview window: See `# Preview Mode` for more information
      -- "3rd/image.nvim",
    },
    keys = {
      {
        '<leader>xt',
        function()
          require('neo-tree.command').execute { toggle = true }
        end,
        desc = '[T]oggle E[x]plorer',
      },
      {
        '<leader>xf',
        function()
          require('neo-tree.command').execute { reveal = true }
        end,
        desc = 'E[x]plore Current [F]ile',
      },
      {
        '<leader>xg',
        function()
          require('neo-tree.command').execute { show = true, source = 'git_status' }
        end,
        desc = 'E[x]plore [G]it',
      },
      {
        '<leader>xb',
        function()
          require('neo-tree.command').execute { show = true, source = 'buffers' }
        end,
        desc = 'E[x]plore [B]uffers',
      },
    },

    -- Neotree should be displayed at startup if an arugment is passed
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require 'neo-tree'
        end
      end
    end,

    -- Add some configurations for Neotree
    config = function()
      require('neo-tree').setup {
        popup_border_style = 'rounded',
        enable_diagnostics = true,
        sort_case_insensitive = true,
        window = {
          -- Customize Neotree keybindings
          mappings = {
            ['<space>'] = 'none',
            ['Y'] = {
              function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.setreg('+', path, 'c')
              end,
              desc = 'Copy Path to Clipboard',
            },
            ['O'] = {
              function(state)
                require('lazy.util').open(state.tree:get_node().path, { system = true })
              end,
              desc = 'Open with System Application',
            },
          },
        },
        default_component_configs = {
          indent = {
            -- expander config, needed for nesting files
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
        },
        event_handlers = {
          { -- Auto close sidebar when file opened
            event = 'file_opened',
            handler = function(file_path)
              -- auto close
              -- vimc.cmd("Neotree close")
              -- OR
              require('neo-tree.command').execute { action = 'close' }
            end,
          },
        },
      }
    end,
  },
}
