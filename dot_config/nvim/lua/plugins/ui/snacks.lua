return {
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = false },
      image = { enabled = true },
      statuscolumn = {
        folds = {
          open = true,
          git_hl = true,
        },
      },
      dashboard = {
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
    },
  },
}
