---@class ComposeArgs
---@field project_name string Docker compose project name
---@field compose_file string Path to the docker compose file
---@field service_name string Name of the service to run the command in
---@field command string Command to run inside the container

--- Create a docker compose command for running Python inside a service container.
---@param root string Path to the working directory inside the container
---@param args ComposeArgs Docker compose arguments
---@return string[] Array of command arguments usable in neotest-python adapter
local function get_python_compose_command(root, args)
  local command = vim.split(args.command, '%s+')
  return {
    'docker',
    'compose',
    '-p',
    args.project_name,
    '-f',
    args.compose_file,
    'exec',
    '-T',
    '-w',
    root,
    args.service_name,
    unpack(command),
  }
end

--- Copied from neotest-vitest source code (not exported) to add support for monorepo with Yarn PnP:
--- https://github.com/marilari88/neotest-vitest/blob/f01addc6f07b79ef1be5f4297eafbee9e0959018/lua/neotest-vitest/init.lua#L176
---@param path string
---@return string
local function getVitestCommand(path)
  local util = require 'neotest-vitest.util'
  local rootPath = util.find_node_modules_ancestor(path)
  local vitestBinary = util.path.join(rootPath, 'node_modules', '.bin', 'vitest')

  if util.path.exists(vitestBinary) then
    return vitestBinary
  end

  local gitRootPath = util.find_git_ancestor(path)
  if gitRootPath then
    vitestBinary = util.path.join(gitRootPath, 'node_modules', '.bin', 'vitest')
    if util.path.exists(vitestBinary) then
      return vitestBinary
    end
  end

  -- NOTE: This is a workaround to support monorepo with Yarn workspaces and SDK (Yarn PnP)
  if require('utils').is_yarn_pnp(gitRootPath) then
    return 'yarn exec vitest'
  end

  return 'vitest'
end

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    -- Add your own test adapters
    'nvim-neotest/neotest-python',
    'marilari88/neotest-vitest',
  },
  opts = {
    floating = {
      border = 'rounded',
    },
    output = {
      open_on_run = false,
    },
    quickfix = {
      open = function()
        require('trouble').open { mode = 'quickfix', focus = false }
      end,
    },
  },
  config = function(_, opts)
    -- Replace newline and tab characters with space for more compact diagnostics
    local neotest_ns = vim.api.nvim_create_namespace 'neotest'
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)

    -- Refresh and auto close trouble after running tests
    opts.consumers = opts.consumers or {}
    ---@type neotest.Consumer
    opts.consumers.trouble = function(client)
      client.listeners.results = function(adapter_id, results, partial)
        if partial then
          return
        end
        local tree = assert(client:get_position(nil, { adapter = adapter_id }))

        local failed = 0
        for pos_id, result in pairs(results) do
          if result.status == 'failed' and tree:get_key(pos_id) then
            failed = failed + 1
          end
        end
        vim.schedule(function()
          local trouble = require 'trouble'
          if trouble.is_open() then
            trouble.refresh()
            if failed == 0 then
              trouble.close()
            end
          end
        end)
        return {}
      end
    end

    ---@type ComposeArgs
    local compose_args
    if vim.env.NEOTEST_RUN_MODE == 'compose' then
      -- NOTE: These mounts are required to run neotest inside the container and persist test results and cache between runs:
      -- ${HOME}/.local/share/nvim:${HOME}/.local/share/nvim:ro
      -- /tmp/nvim.${USER}:/tmp/nvim.${USER}

      compose_args = {
        project_name = vim.env.NEOTEST_COMPOSE_PROJECT_NAME,
        compose_file = vim.env.NEOTEST_COMPOSE_FILE,
        service_name = vim.env.NEOTEST_COMPOSE_SERVICE_NAME,
        command = vim.env.NEOTEST_COMPOSE_COMMAND,
      }
    end

    opts.adapters = {
      require 'neotest-python' {
        -- FIXME: neotest-python doesn't support running tests in the Docker container:
        -- https://github.com/nvim-neotest/neotest-python/issues/71
        python = function(root)
          if compose_args then
            if not compose_args.command then
              compose_args.command = 'python'
            end
            return get_python_compose_command(root, compose_args)
          end

          return require('neotest-python.base').get_python_command(root)
        end,
      },
      require 'neotest-vitest' {
        -- FIXME: neotest-vitest is not working properly with monorepo and Yarn workspaces
        vitestCommand = function(path)
          return getVitestCommand(path)
        end,
      },
    }

    require('neotest').setup(opts)
  end,
  keys = {
    {
      '<leader>ta',
      function()
        require('neotest').run.attach()
      end,
      desc = '[A]ttach to Test',
    },
    {
      '<leader>tt',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run File',
    },
    {
      '<leader>tT',
      function()
        require('neotest').run.run(vim.uv.cwd())
      end,
      desc = 'Run All [T]est Files',
    },
    {
      '<leader>tr',
      function()
        require('neotest').run.run()
      end,
      desc = '[R]un Nearest',
    },
    {
      '<leader>td',
      function()
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = '[D]ebug Nearest',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Run [L]ast',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle [S]ummary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open { enter = true, auto_close = true }
      end,
      desc = 'Show [O]utput',
    },
    {
      '<leader>tO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle [O]utput Panel',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.stop()
      end,
      desc = '[S]top',
    },
    {
      '<leader>tw',
      function()
        require('neotest').watch.toggle(vim.fn.expand '%')
      end,
      desc = 'Toggle [W]atch',
    },
    {
      '<leader>ty',
      function()
        local tree = require('neotest').run.get_tree_from_args {}
        if not tree then
          vim.notify('No test found under cursor', vim.log.levels.WARN)
          return
        end

        local id = tree:data().id
        local prefix = vim.fn.getcwd() .. package.config:sub(1, 1)
        local test_id = id:sub(#prefix + 1)
        vim.fn.setreg('+', test_id)
        vim.notify('Copied ' .. test_id .. ' to clipboard!')
      end,
      desc = '[Y]ank Test ID',
    },
  },
}
