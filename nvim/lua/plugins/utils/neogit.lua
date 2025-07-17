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
    config = true,
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
