return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = { enabled = false },
    notifier = { enabled = false, top_down = false },
    picker = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    words = { enabled = false },
    bigfile = { -- Prevents attaching LSP and Treesitter to big files
      enabled = true,
    },
    indent = { -- Indent guides and scopes
      enabled = true,
      animate = {
        duration = {
          step = 5,
          total = 100,
        },
      },
    },
    quickfile = { -- Render a single file quickly before loading plugins
      enabled = true,
    },
    input = { -- Better vim.ui.input
      enabled = true,
    },
    image = { -- Image viewer using Kitty Graphics Protocol
      enabled = true,
    },
    statuscolumn = { -- Pretty status column
      enabled = true,
      folds = {
        open = true,
        git_hl = true,
      },
    },
    dashboard = { -- Beautiful declarative dashboards
      enabled = true,
      preset = {
        pick = function(cmd, opts)
          local telescope = require 'telescope.builtin'
          if opts == nil then
            opts = {}
          end

          if cmd == 'files' then
            telescope.find_files(opts)
          elseif cmd == 'live_grep' then
            telescope.live_grep(opts)
          elseif cmd == 'oldfiles' then
            telescope.oldfiles(opts)
          end
        end,
        header = [[
                                                                    
      ████ ██████           █████      ██                     
     ███████████             █████                             
     █████████ ███████████████████ ███   ███████████   
    █████████  ███    █████████████ █████ ██████████████   
   █████████ ██████████ █████████ █████ █████ ████ █████   
 ███████████ ███    ███ █████████ █████ █████ ████ █████  
██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      },
      sections = {
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { section = 'startup' },
      },
    },
    zen = { -- Zen mode
      enabled = true,
      win = {
        width = 0,
      },
      toggles = {
        dim = true,
        git_signs = false,
        diagnostics = false,
        inlay_hints = false,
        ufo = false,
        line_number = false,
        relative_number = false,
        indent = false,
        signcolumn = 'no',
      },
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)

    Snacks.toggle.new {
      id = 'ufo',
      name = 'Toggle UFO',
      get = function()
        return require('ufo').inspect()
      end,
      set = function(state)
        if state == nil then
          require('ufo').enable()
          vim.opt.foldenable = true
          vim.opt.foldcolumn = '1'
        else
          require('noice').cmd 'dismiss'
          require('ufo').disable()
          vim.opt.foldenable = false
          vim.opt.foldcolumn = '0'
        end
      end,
    }
  end,
  keys = {
    {
      '<leader>bdd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Current',
    },
    {
      '<leader>bda',
      function()
        Snacks.bufdelete.all()
      end,
      desc = '[A]ll',
    },
    {
      '<leader>bdo',
      function()
        Snacks.bufdelete.other()
      end,
      desc = '[O]thers',
    },
    {
      '<leader>uz',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle [Z]en Mode',
    },
    {
      '<leader>bu',
      function()
        Snacks.picker.undo()
      end,
      desc = '[U]ndo History',
    },
  },
}
