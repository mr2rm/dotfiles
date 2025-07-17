return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
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
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        -- Lua
        lua = { 'stylua' },

        -- Python
        python = { 'ruff_organize_imports', 'ruff_format' },

        -- TypeScript/JavaScript
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
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
      -- NOTE: This is legacy after `ruff_organize_imports` formatter
      -- formatters = {
      --   ruff_fix = {
      --     -- Always orgnize imports
      --     prepend_args = { '--extend-select', 'I' },
      --   },
      -- },
    },
  },
}
