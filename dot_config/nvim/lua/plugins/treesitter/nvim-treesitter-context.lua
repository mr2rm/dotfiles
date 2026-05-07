local LazyFile = require('utils').LazyFile

return { -- Show your current context
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = LazyFile,
}
