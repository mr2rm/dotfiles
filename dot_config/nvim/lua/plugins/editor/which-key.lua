-- FIXME: There are some overlapping keymaps on health-checking
return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>a', group = '[A]I', icon = { icon = '', color = 'gray' } },
        { '<leader>c', group = '[C]ode', icon = { icon = '', color = 'gray' } },
        { '<leader>g', group = '[G]it', icon = { icon = '󰊢', color = 'gray' } },
        { '<leader>h', group = '[H]arpoon', icon = { icon = '󱡀', color = 'gray' } },
        { '<leader>n', group = '[N]otification', icon = { icon = '󰈸', color = 'gray' } },
        { '<leader>r', group = '[R]ename', icon = { icon = '', color = 'gray' } },
        { '<leader>s', group = '[S]earch', icon = { icon = '', color = 'gray' } },
        { '<leader>t', group = 'File [T]ree', icon = { icon = '', color = 'gray' } },
        { '<leader>x', group = 'Trouble', icon = { icon = '󰙅', color = 'gray' } },
        { '<leader>k', group = '[K]eymaps', icon = { icon = '󰌌', color = 'gray' } },
        -- FIXME: Goes to visual mode instead of Venv
        { '<leader>v', group = '[V]env' },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps',
      },
    },
  },
}
