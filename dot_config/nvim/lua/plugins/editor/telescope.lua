-- TODO: Search relative to open buffer
--  Use `require('telescope.utils').buffer_dir()` for `cwd` on `live_grep` and etc.

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      --
      local builtin = require 'telescope.builtin'
      local actions = require 'telescope.actions'
      local actions_state = require 'telescope.actions.state'

      local show_in_file_tree = function(prompt_bufnr)
        local nvim_tree = require 'nvim-tree.api'
        actions.close(prompt_bufnr)
        local selection = actions_state.get_selected_entry()
        nvim_tree.tree.open()
        nvim_tree.tree.find_file(selection.cwd .. '/' .. selection.value)
      end

      local find_hidden_files = function()
        local current_line = actions_state.get_current_line()
        return builtin.find_files { hidden = true, default_text = current_line }
      end

      local find_ignore_files = function()
        local current_line = actions_state.get_current_line()
        return builtin.find_files { no_ignore = true, default_text = current_line }
      end

      local open_after_tree = function(prompt_bufnr)
        vim.defer_fn(function()
          actions.select_default(prompt_bufnr)
        end, 100) -- Delay allows filetype and plugins to settle before opening
      end

      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        pickers = {
          find_files = {
            mappings = {
              i = {
                ['<C-h>'] = find_hidden_files,
                ['<C-g>'] = find_ignore_files,
                ['<C-f>'] = show_in_file_tree,
              },
            },
          },
          buffers = {
            mappings = {
              i = {
                ['<C-w>'] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          file_ignore_patterns = { '.git/' },
          sorting_strategy = 'ascending',
          layout_strategy = 'flex',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
            },
            vertical = {
              prompt_position = 'top',
              preview_height = 0.55,
            },
            flex = {
              flip_columns = 120,
            },
          },
          -- NOTE: Resolve race condition with NvimTree:
          --  https://github.com/nvim-treesitter/nvim-treesitter/issues/7952
          mappings = {
            i = { ['<CR>'] = open_after_tree },
            n = { ['<CR>'] = open_after_tree },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'noice')

      -- Find directory and focus in Nvim-tree
      -- NOTE: Needs fd to be installed (https://github.com/sharkdp/fd)
      -- TODO: Can be deprecated
      vim.keymap.set('n', '<leader>sF', function()
        builtin.find_files {
          prompt_title = 'Find Folders',
          find_command = { 'fdfind', '--type', 'directory' },
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              show_in_file_tree(prompt_bufnr)
            end)
            return true
          end,
        }
      end, { desc = '[F]olders' })
    end,
    keys = { -- See `:help telescope.builtin`
      -- Grep String
      { -- TODO: <leader>sG -> CWD ({ root = false })
        '<leader>sg',
        '<cmd>Telescope live_grep<cr>', -- builtin.live_grep,
        desc = '[G]rep All',
      },
      {
        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = 'Grep Open Files',
      },
      {
        -- Slightly advanced example of overriding default behavior and theme
        '<leader>sb',
        function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          local dropdown = require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
          require('telescope.builtin').current_buffer_fuzzy_find(dropdown)
        end,
        desc = 'Grep Current [B]uffer',
      },
      { '<leader>sw', '<cmd>Telescope grep_string word_match=-w<cr>', desc = '[W]ord' },
      { '<leader>sw', '<cmd>Telescope grep_string<cr>', mode = 'v', desc = 'Selection' },

      -- Find Files
      { -- TODO: <leader>fR -> CWD ({ cwd = vim.uv.cwd() })
        '<leader>s.', -- <leader>sr, <leader>fr
        '<cmd>Telescope oldfiles<cr>', -- builtin.oldfiles
        desc = 'Recent Files',
      },
      {
        '<leader>sf', -- <leader><space>
        '<cmd>Telescope find_files<cr>', -- builtin.find_files,
        desc = '[F]iles',
      },
      { -- Shortcut for searching your Neovim configuration files
        '<leader>sn', -- <leader>fc
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[N]eovim Files',
      },
      {
        '<leader>so', -- <leader>, <leader>fb
        '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', -- builtin.buffers
        desc = '[O]pen Files',
      },

      -- Todo Comments
      {
        '<leader>st',
        '<cmd>TodoTelescope<cr>',
        desc = '[T]odo List',
      },
      {
        '<leader>sT',
        '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
        desc = '[T]odo Fix List',
      },

      -- Misc
      { '<leader>s:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
      {
        '<leader>sr', -- <leader>sR
        '<cmd>Telescope resume<cr>', -- builtin.resume
        desc = '[R]esume',
      },
      {
        '<leader>sh',
        '<cmd>Telescope help_tags<cr>', -- builtin.help_tags
        desc = '[H]elp Pages',
      },
      {
        '<leader>sk',
        '<cmd>Telescope keymaps<cr>', -- builtin.keymaps
        desc = '[K]eymaps',
      },
      { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document [D]iagnostics' },
      {
        '<leader>sD',
        '<cmd>Telescope diagnostics<cr>', -- builtin.diagnostics
        desc = 'Workspace [D]iagnostics',
      },
    },
  },
}
