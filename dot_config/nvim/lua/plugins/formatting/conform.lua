return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      desc = '[F]ormat',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 5000, -- just because of `eslint`
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      -- Lua
      lua = { 'stylua' },

      -- Python
      python = { 'ruff_organize_imports', 'ruff_format' },

      -- TypeScript/JavaScript
      javascript = { 'prettier', 'eslint' },
      javascriptreact = { 'prettier', 'eslint' },
      typescript = { 'prettier', 'eslint' },
      typescriptreact = { 'prettier', 'eslint' },
      html = { 'prettier' },
      css = { 'prettier' },
      json = { 'prettier' },

      -- C/C++
      cpp = { 'clang_format' },

      -- Markdown
      markdown = { 'prettier' },

      -- YAML
      -- NOTE: Use built-in yamlls formatter instead
      -- yaml = { 'prettier' },
    },
    formatters = {
      eslint = {
        command = 'eslint',
        args = { '--fix', '--quiet', '$FILENAME' },
        stdin = false,
        exit_codes = { 0, 1 },
      },
      -- NOTE: This is legacy after using `ruff_organize_imports` formatter
      -- ruff_fix = {
      --   -- Always orgnize imports
      --   prepend_args = { '--extend-select', 'I' },
      -- },
    },
  },
  config = function(_, opts)
    local utils = require 'utils'

    -- Support Yarn2 (PnP) projects
    if utils.is_yarn_pnp() then
      local eslint = opts.formatters.eslint
      eslint.command = 'yarn'
      eslint.args = { 'exec', 'eslint', unpack(eslint.args) }
    end

    require('conform').setup(opts)
  end,
}
