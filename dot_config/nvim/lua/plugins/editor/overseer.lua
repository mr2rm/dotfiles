return {
  'stevearc/overseer.nvim',
  lazy = false, -- plugin is self-lazy-loading
  cmd = {
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerRun',
    'OverseerTaskAction',
  },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    -- TODO: Review `dap` and `task_list` configuration copied from LazyVim
    dap = false,
    task_list = {
      keymaps = {
        ['<C-j>'] = false,
        ['<C-k>'] = false,
      },
    },
    form = {
      border = 'rounded',
      win_opts = {
        winblend = 0,
      },
    },
    task_win = {
      border = 'rounded',
      win_opts = {
        winblend = 0,
      },
    },
  },
  keys = {
    { '<leader>rt', '<cmd>OverseerToggle!<cr>', desc = '[T]oggle Task List' },
    { '<leader>rr', '<cmd>OverseerRun<cr>', desc = '[R]un Task' },
    { '<leader>ra', '<cmd>OverseerTaskAction<cr>', desc = 'Task [A]ction' },
  },
}
