return { -- Neogit
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    -- TODO: Configure diffview

    -- Only one of these is needed, not both.
    'nvim-telescope/telescope.nvim', -- optional
    -- 'ibhagwan/fzf-lua', -- optional
  },
  cmd = 'Neogit',
  config = function(_, opts)
    require('neogit').setup(opts)

    -- NOTE: Disable folds and statuscolumn
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        if vim.bo.filetype == 'NeogitStatus' then
          require('utils').disable_fold_and_statuscolumn()
        end
      end,
    })
  end,
  opts = {
    graph_style = 'unicode',
    signs = {
      section = { '', '' },
      item = { '', '' },
    },
    integrations = {
      telescope = true,
      diffview = true,
    },
  },
  keys = {
    { '<leader>gg', '<cmd>Neogit<CR>', desc = 'Neogit' },
  },
}
