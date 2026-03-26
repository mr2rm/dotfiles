return { -- File Tree
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    {
      '<leader>ft',
      '<cmd>NvimTreeToggle<cr>',
      desc = '[T]oggle',
    },
    {
      '<leader>ff',
      '<cmd>NvimTreeFindFile<cr>',
      desc = 'Current [F]ile',
    },
    {
      '<leader>fb',
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
    -- NOTE: Disable folds and statuscolumn
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        if vim.bo.filetype == 'NvimTree' then
          require('ufo').detach()
          vim.opt_local.foldenable = false
          vim.opt_local.foldcolumn = '0'
          vim.opt_local.statuscolumn = ''
        end
      end,
    })
  end,
}
