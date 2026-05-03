-- TODO: Temporary local patch for using deprecated Neovim LSP API:
-- Patched `~/.local/share/nvim/lazy/copilot-cmp/lua/copilot_cmp/source.lua` by
-- replacing `client.is_stopped()` with `client:is_stopped()`.
-- Remove this once `copilot-cmp` includes the upstream fix or is replaced.

return {
  'zbirenbaum/copilot-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      build = ':Copilot auth',
      event = 'InsertEnter',
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
        },

        -- NOTE: By default `gpt-41-copilot` model is used for inline suggestions.
        -- https://docs.github.com/en/copilot/concepts/completions/code-suggestions#about-the-ai-model-used-for-copilot-inline-suggestions
        -- copilot_model = 'gpt-41-copilot',
      },
    },
  },
  opts = {},
  config = function(_, opts)
    local copilot_cmp = require 'copilot_cmp'
    copilot_cmp.setup(opts)

    vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

    -- attach cmp source whenever copilot attaches
    -- fixes lazy-loading issues with the copilot cmp source
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client.name == 'copilot' then
          copilot_cmp._on_insert_enter {}
        end
      end,
    })
  end,
}
