return {
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      -- Lazy-load plugin on select
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end

      -- Lazy-load plugin on input
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        insert_only = false,
      },
    },
  },
}
