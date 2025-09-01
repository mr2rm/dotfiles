local LazyFile = require('utils').LazyFile

return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    event = LazyFile,
    main = 'ibl',
    opts = {},
  },
}
