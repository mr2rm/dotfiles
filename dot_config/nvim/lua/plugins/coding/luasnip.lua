return { -- Snippet Engine
  'l3mon4d3/luasnip',
  lazy = true,
  build = (function()
    -- build step is needed for regex support in snippets.
    -- this step is not supported in many windows environments.
    -- remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  dependencies = {
    -- `friendly-snippets` contains a variety of premade snippets.
    --    see the readme about individual language/framework/plugin snippets:
    --    https://github.com/rafamadriz/friendly-snippets
    {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
  opts = {
    delete_check_events = 'TextChanged',
  },
  keys = {
    {
      '<leader>cN',
      function()
        require('luasnip').unlink_current()
      end,
      desc = 'Unlink Snippet',
    },
  },
}
