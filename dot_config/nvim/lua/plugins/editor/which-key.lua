-- FIXME: There are some overlapping keymaps on health-checking
return { -- Show pending keybinds
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    spec = {
      { '<leader>a', group = '[A]I', icon = { icon = '' } },
      { '<leader>b', group = '[B]uffers', icon = { icon = '' } },
      { '<leader>bd', group = '[D]elete' },
      { '<leader>c', group = '[C]ode', icon = { icon = '' } },
      { '<leader>d', group = '[D]ebug', icon = { icon = '' } },
      { '<leader>f', group = '[F]iles', icon = { icon = '' } },
      { '<leader>g', group = '[G]it', icon = { icon = '󰊢' } },
      { '<leader>k', group = '[K]eymaps', icon = { icon = '󰌌' } },
      { '<leader>m', group = '[M]arks', icon = { icon = '󱡀' } },
      { '<leader>n', group = '[N]otifications', icon = { icon = '󰈸' } },
      { '<leader>r', group = '[R]un', icon = { icon = '' } },
      { '<leader>s', group = '[S]earch', icon = { icon = '' } },
      { '<leader>sF', group = '[F]ile' },
      { '<leader>sG', group = '[G]rep' },
      { '<leader>sn', group = '[N]eovim' },
      { '<leader>t', group = '[T]est', icon = { icon = '󰙨' } },
      { '<leader>u', group = '[U]I', icon = { icon = '󰙵' } },
      { '<leader>x', group = 'Diagnostics/Quickfix', icon = { icon = '󱖫' } },
      { '[', group = 'Prev', icon = { icon = '󱦱' } },
      { ']', group = 'Next', icon = { icon = '󱦰' } },
      { 'g', group = '[G]oto', icon = { icon = '󱞷' } },
      { 'z', group = 'fold', icon = { icon = '' } },
    },
  },
  keys = {
    {
      '<leader>b?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Local Keymaps',
    },
  },
}
