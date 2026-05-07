---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if parser exists and load it
  if not vim.treesitter.language.add(language) then
    return
  end

  -- Enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enables treesitter based folds
  -- For more info on folds see `:help folds`
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- In case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
  if has_indent_query then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    require('nvim-treesitter').setup(opts)

    -- Ensure basic parser are installed
    local ensure_installed = {
      'bash',
      'c',
      'cmake',
      'cpp',
      'diff',
      'dockerfile',
      'dot',
      'gitignore',
      'html',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'luadoc',
      'luap',
      'make',
      'markdown',
      'markdown_inline',
      'printf',
      'python',
      'query',
      'regex',
      'sql',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    }
    require('nvim-treesitter').install(ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end

        local available_parsers = require('nvim-treesitter').get_available()
        local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
        if vim.tbl_contains(installed_parsers, language) then
          -- Enable the parser if it is installed
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          -- If a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
          require('nvim-treesitter').install(language):await(function()
            treesitter_try_attach(buf, language)
          end)
        else
          -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
