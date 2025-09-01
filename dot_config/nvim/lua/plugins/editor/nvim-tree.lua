return { -- File Tree
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    {
      '<leader>tt',
      '<cmd>NvimTreeToggle<cr>',
      desc = '[T]oggle',
    },
    {
      '<leader>tf',
      '<cmd>NvimTreeFindFile<cr>',
      desc = 'Current [F]ile',
    },
    {
      '<leader>tb',
      '<cmd>NvimTreeCollapseKeepBuffers<cr>',
      desc = '[B]uffers',
    },
  },
  config = function()
    require('nvim-tree').setup {
      hijack_cursor = true,
      diagnostics = {
        enable = true,
      },
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        signcolumn = 'auto',
        preserve_window_proportions = true,
      },
      renderer = {
        full_name = true,
        highlight_git = 'all',
        highlight_diagnostics = 'all',
        highlight_modified = 'all',
        highlight_bookmarks = 'all',
        indent_markers = {
          enable = true,
        },
        icons = {
          git_placement = 'right_align',
          modified_placement = 'right_align',
          diagnostics_placement = 'right_align',
        },
      },
      filters = {
        dotfiles = true,
      },
      tab = {
        sync = {
          close = true,
        },
      },
      -- TODO: Review other available options for actions
      actions = {
        open_file = {
          quit_on_open = true,
        },
        change_dir = {
          global = true,
        },
      },
    }
  end,
}
