return { -- Debugging support (requires language specific adapters)
  'mfussenegger/nvim-dap',
  dependencies = {
    { -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',
      opts = {
        floating = {
          border = 'rounded',
        },
      },
    },
    'thehamsta/nvim-dap-virtual-text',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    -- TODO: Can't use `mason-tool-installer.nvim` same as LSP?
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('nvim-dap-virtual-text').setup()

    -- NOTE: Debugpy includes a debugpy-adapter executable to use in place of the python executable.
    require('dap-python').setup 'debugpy-adapter'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        python = function()
          -- NOTE: Add path mappings to support Docker
          for _, config in ipairs(dap.configurations.python) do
            if config.name == 'attach' then
              config.pathMappings = function()
                local remote = vim.fn.input 'Remote root [.]: '
                remote = remote ~= '' and remote or '.'
                return {
                  {
                    localRoot = vim.fn.getcwd(),
                    remoteRoot = remote,
                  },
                }
              end
              break
            end
          end
        end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs (not Mason names!) you want
        'python', -- debugpy
      },
    }

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
    local icons = {
      Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
      Breakpoint = { ' ' },
      BreakpointCondition = { ' ' },
      BreakpointRejected = { ' ', 'DiagnosticError' },
      LogPoint = { '.>' },
    }
    for name, sign in pairs(icons) do
      vim.fn.sign_define('Dap' .. name, {
        text = sign[1],
        texthl = sign[2] or 'DiagnosticInfo',
        linehl = sign[3],
        numhl = sign[3],
      })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
  keys = {
    {
      '<leader>dt',
      function()
        require('dapui').toggle()
      end,
      desc = '[T]oggle UI',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval(nil, { enter = true })
      end,
      desc = '[E]val',
      mode = { 'n', 'x' },
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[B]reakpoint Condition',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle [B]reakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = '[C]ontinue/Run',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Run to [C]ursor',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = '[G]o to Line (No Execute)',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Step [I]nto',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = 'Down',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = 'Up',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = 'Run [L]ast (Re-run)',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Step [O]ut',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_over()
      end,
      desc = 'Step [O]ver',
    },
    {
      '<leader>dP',
      function()
        require('dap').pause()
      end,
      desc = '[P]ause',
    },
    {
      '<leader>dT',
      function()
        require('dap').terminate()
      end,
      desc = '[T]erminate',
    },
  },
}
