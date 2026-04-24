return {
  'danymat/neogen',
  dependencies = {
    'L3MON4D3/LuaSnip',
  },
  cmd = 'Neogen',
  opts = {
    snippet_engine = 'luasnip',
  },
  keys = {
    {
      '<leader>cn',
      function()
        local func_ft = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        }
        if vim.tbl_contains(func_ft, vim.bo.filetype) then
          require('neogen').generate { type = 'func' }
        else
          require('neogen').generate()
        end
      end,
      desc = 'A[n]notate',
    },
  },
}
