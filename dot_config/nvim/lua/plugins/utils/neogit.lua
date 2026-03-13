return {
  { -- Neogit
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
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'NeogitStatus',
        callback = function()
          require('ufo').detach()
          vim.opt_local.foldenable = false
          vim.opt_local.foldcolumn = '0'
          vim.opt_local.statuscolumn = ''
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
  },
}
