return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      {
        'mason-org/mason.nvim',
        opts = {
          ui = { border = 'rounded' },
        },
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- NOTE: fidget was disabled in favor of noice
      --
      -- -- Useful status updates for LSP.
      -- -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },

      -- Load JSON schemas for yamlls
      {
        'b0o/SchemaStore.nvim',
        lazy = true,
        version = false, -- last release is way too old
      },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local which_key = require 'which-key'
          local telescope_builtin = require 'telescope.builtin'
          local lsp_mapping = require('utils').lsp_mapping

          -- LSP mappings
          which_key.add({
            -- NOTE: LSP mappings

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            lsp_mapping('gd', telescope_builtin.lsp_definitions, '[G]oto [D]efinitions'),
            --
            -- Jump to the DECLARATION of the word under your cursor.
            --  For example, in C this would take you to the header.
            lsp_mapping('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration'),

            -- Find references for the word under your cursor.
            lsp_mapping('gr', telescope_builtin.lsp_references, '[G]oto [R]eferences'),

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            lsp_mapping('gI', telescope_builtin.lsp_implementations, '[G]oto [I]mplementations'),

            -- Opens a popup that displays documentation about the word under your cursor
            --  See `:help K` for why this keymap.
            --  or a suggestion from your LSP for this to activate.
            lsp_mapping('K', vim.lsp.buf.hover, 'Documentation'),

            -- NOTE: Code mappings

            -- Execute a code action, usually your cursor needs to be on top of an error
            --  or a suggestion from your LSP for this to activate.
            { '<leader>ca', vim.lsp.buf.code_action, desc = '[A]ctions' },

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            { '<leader>ct', telescope_builtin.lsp_type_definitions, desc = '[T]ype Definition' },

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            { '<leader>cr', vim.lsp.buf.rename, desc = '[R]ename' },

            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            { '<leader>cs', telescope_builtin.lsp_dynamic_workspace_symbols, desc = 'Workspace [S]ymbols' },

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            { '<leader>cS', telescope_builtin.lsp_document_symbols, desc = 'Document [S]ymbols' },
          }, { mode = 'n', buffer = event.buf })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            vim.keymap.set('n', '<leader>H', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, { desc = 'Toggle Inlay [H]int' })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

      -- NOTE: For running servers in containers you can follow this guide:
      --  https://github.com/neovim/nvim-lspconfig/wiki/Running-language-servers-in-containers

      local servers = {
        -- gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        -- Lua
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        -- Python
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
          },
          capabilities = {
            textDocument = {
              publishDiagnostics = {
                tagSupport = {
                  valueSet = { 2 },
                },
              },
            },
          },
        },
        ruff = { -- LSP/Linter/Formatter for Python (replacement for black, isort, etc.)
          on_attach = function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end,
        },

        -- C/C++
        clangd = {
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
        },

        -- JavaScript/TypeScript
        ts_ls = {
          init_options = {
            tsserver = {
              -- NOTE: This is the path to the TypeScript SDK installed by Yarn (PnP)
              path = '.yarn/sdks/typescript/lib',
            },
          },
        },
        -- FIXME: ESLint LSP still cannot work with Yarn PnP. On editing a file,
        -- it will throw this error regularly:
        --    Error running eslint: ENOENT: no such file or directory
        -- Can be reproduced by `:lua require('lint').try_lint()`, and might be resolved
        -- by this PR: `https://github.com/neovim/nvim-lspconfig/pull/3900`.
        -- Until then, `eslint_d` will be used as linter and formatter.
        -- eslint = {
        --   settings = {
        --     nodePath = '.yarn/sdks',
        --     workingDirectories = { mode = 'auto' },
        --   },
        -- },

        -- Docker
        dockerls = {},
        docker_compose_language_service = {},

        -- Markdown
        marksman = {},

        -- YAML
        yamlls = {
          on_attach = function(client)
            -- Did not work in the capabilities table!
            client.server_capabilities.documentFormattingProvider = true
          end,
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- Lazy-load schema store when needed
          on_new_config = function(new_config)
            local schemas = {
              kubernetes = { 'k8s*.yaml', 'k8s*/**/*.yaml', 'kube*.yaml', 'kube*/**/*.yaml' },
            }
            local schemastore_schemas = require('schemastore').yaml.schemas {
              select = {
                'kustomization.yaml',
                'gitlab-ci',
                'docker-compose.yml',
                'Helm Chart.yaml',
              },
              -- extra = {
              --     {
              --       description = 'Kubernetes JSON Schema',
              --       fileMatch = { 'k8s*.yaml', 'k8s*/**/*.yaml', 'kube*.yaml', 'kube*/**/*.yaml' },
              --       name = 'kubernetes',
              --       url = 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.8/all.json',
              --     },
              -- },
            }
            new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', schemas, schemastore_schemas)
          end,
          settings = {
            yaml = {
              validate = true,
              hover = true,
              completion = true,
              -- Chose built-in formatter of LSP over prettier
              format = {
                enable = true,
              },
              schemaStore = {
                -- Disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- NOTE: Configuration for Java is handled by nvim-jdtls
        'jdtls', -- Java language server
        'stylua', -- Used to format Lua code
        'hadolint', -- Linter for Dockerfile
        'markdownlint', -- Linter/Formatter for Markdown
        'prettier', -- Formatter for YAML, Markdown, JSON, HTML, CSS, JS, and etc.
        'clang-format', -- Formatter for C/C++, Java, JS, JSON, Protobuf, and etc.
        'eslint_d', -- Linter for JavaScript/TypeScript
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      ---@type MasonLspconfigSettings
      ---@diagnostic disable-next-line: missing-fields
      require('mason-lspconfig').setup {
        automatic_enable = vim.tbl_keys(servers or {}),
      }

      -- Installed LSPs are configured and enabled automatically with mason-lspconfig
      -- The loop below is for overriding the default configuration of LSPs with the
      -- ones in the servers table
      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, config)
      end

      require('lspconfig.ui.windows').default_options.border = 'rounded'
    end,
  },
}
