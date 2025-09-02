return {
  'kevinhwang91/nvim-ufo',
  event = 'FileType',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  opts = {
    provider_selector = function()
      return { 'lsp', 'indent' }
    end,
  },
  keys = {
    {
      'zR',
      function()
        require('ufo').openAllFolds()
      end,
      mode = 'n',
      desc = 'Open all folds',
    },
    {
      'zM',
      function()
        require('ufo').closeAllFolds()
      end,
      mode = 'n',
      desc = 'Close all folds',
    },
    {
      'zK',
      function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      mode = 'n',
      desc = 'Peek fold',
    },
  },
}
