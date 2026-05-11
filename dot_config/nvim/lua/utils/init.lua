local utils = {}

utils.LazyFile = { 'BufReadPost', 'BufWritePost', 'BufNewFile' }

utils.buffer_keymap_setter = function(buf)
  return function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
  end
end

utils.is_yarn_pnp = function()
  local root_dir = vim.fn.getcwd()
  return vim.uv.fs_stat(root_dir .. '/.pnp.cjs') or vim.uv.fs_stat(root_dir .. '/.pnp.js')
end

utils.disable_fold_and_statuscolumn = function()
  require('ufo').detach()

  vim.opt_local.foldenable = false
  vim.opt_local.foldcolumn = '0'
  vim.opt_local.statuscolumn = ''
end

return utils
