return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = '[S]ymbols' },
    {
      '<leader>xS',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP References/Definitions',
    },
    { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = '[L]ocation List' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = '[Q]uickfix List' },
    {
      '[q',
      function()
        if require('trouble').is_open() then
          require('trouble').prev { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Previous Quickfix Item',
    },
    {
      ']q',
      function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Next Quickfix Item',
    },
    {
      '<leader>xd',
      vim.diagnostic.open_float,
      desc = 'Show Current [D]iagnostic',
    },

    -- NOTE: Todo Comments
    {
      '<leader>xt',
      '<cmd>Trouble todo<cr>',
      desc = '[T]odo List',
    },
    {
      '<leader>xT',
      '<cmd>Trouble todo filter = {tag = {TODO, FIX, FIXME}}<cr>',
      desc = 'Fix List',
    },
  },
}
