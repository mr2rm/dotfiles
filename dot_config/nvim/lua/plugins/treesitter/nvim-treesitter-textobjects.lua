return { -- Text-objects for Treesitter
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'VeryLazy',
  opts = {
    move = {
      set_jumps = true, -- whether to set jumps in the jumplist
    },
  },
  config = function(_, opts)
    require('nvim-treesitter-textobjects').setup(opts)
  end,
  keys = {
    {
      ']f',
      function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Next [F]unction Start',
    },
    {
      ']c',
      function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Next [C]lass Start',
    },
    {
      ']a',
      function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Next Parameter Start',
    },
    {
      ']F',
      function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Next [F]unction End',
    },
    {
      ']C',
      function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Next [C]lass End',
    },
    {
      ']A',
      function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.inner', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Next Parameter End',
    },
    {
      '[f',
      function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Previous [F]unction Start',
    },
    {
      '[c',
      function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Previous [C]lass Start',
    },
    {
      '[a',
      function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Previous Parameter Start',
    },
    {
      '[F',
      function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Previuos [F]unction End',
    },
    {
      '[C',
      function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Previuos [C]lass End',
    },
    {
      '[A',
      function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.inner', 'textobjects')
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Go to Previuos Parameter End',
    },
  },
}
