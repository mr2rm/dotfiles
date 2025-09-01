local utils = {}

utils.LazyFile = { 'BufReadPost', 'BufWritePost', 'BufNewFile' }

-- NOTE: Remember that Lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself.
--
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
utils.lsp_mapping = function(keys, func, desc)
  return { keys, func, desc = 'LSP: ' .. desc, icon = '' }
end

return utils
