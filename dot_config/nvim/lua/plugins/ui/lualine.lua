--- @param hide_width number? hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    -- Hide
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ''
    end
    -- Truncate
    -- Length of string is greater than `trunc_len`
    if trunc_len and #str > trunc_len then
      -- Window width is smaller than `trunc_width`
      if trunc_width == nil or win_width < trunc_width then
        return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
      end
    end
    -- No change
    return str
  end
end

local function avante_provider()
  avante_config = require 'avante.config'
  if not avante_config.provider then
    return '󰚩 -'
  end

  return '󰚩 ' .. avante_config.provider
end

local function mcp_count()
  -- Check if MCPHub is loaded
  if not vim.g.loaded_mcphub then
    return '󰐻 -'
  end

  local count = vim.g.mcphub_servers_count or 0
  local status = vim.g.mcphub_status or 'stopped'
  local executing = vim.g.mcphub_executing

  -- Show "-" when stopped
  if status == 'stopped' then
    return '󰐻 -'
  end

  -- Show spinner when executing, starting, or restarting
  if executing or status == 'starting' or status == 'restarting' then
    local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    local frame = math.floor(vim.loop.now() / 100) % #frames + 1
    return '󰐻 ' .. frames[frame]
  end

  return '󰐻 ' .. count
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = { theme = 'tokyonight', globalstatus = true },
      extensions = { 'avante', 'lazy', 'mason', 'nvim-tree', 'quickfix', 'trouble' },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'branch', fmt = trunc(nil, 20, nil, false) },
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 }, fmt = trunc(nil, 20, 100, false) },
          { 'filename', fmt = trunc(nil, 20, 100, false) },
        },
        lualine_x = {
          {
            function()
              return require('noice').api.status.command.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.command.has()
            end,
            color = { fg = '#ff9e64' },
          },
          {
            function()
              return require('noice').api.status.mode.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.mode.has()
            end,
            color = { fg = '#ff9e64' },
          },
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
          },
        },
        -- NOTE: This section needs some improvements

        lualine_y = {
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
          'venv-selector',
          {
            function()
              return mcp_count() .. ' ' .. avante_provider()
            end,
            color = function()
              if not vim.g.loaded_mcphub then
                return { fg = '#6c7086' } -- Gray for not loaded
              end

              local status = vim.g.mcphub_status or 'stopped'
              if status == 'ready' or status == 'restarted' then
                return { fg = '#50fa7b' } -- Green for connected
              elseif status == 'starting' or status == 'restarting' then
                return { fg = '#ffb86c' } -- Orange for connecting
              else
                return { fg = '#ff5555' } -- Red for error/stopped
              end
            end,
          },
        },
        lualine_z = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
      },
      tabline = {
        lualine_a = { 'tabs' },
        lualine_z = { 'buffers' },
      },
    }
  end,
}
