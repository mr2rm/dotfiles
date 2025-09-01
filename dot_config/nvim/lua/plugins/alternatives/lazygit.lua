return {
  { -- Lazygit
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>glg', '<cmd>LazyGit<cr>', desc = 'Lazy[G]it' },
      {
        '<leader>gls',
        function()
          require('telescope').extensions.lazygit.lazygit()
        end,
        desc = '[S]earch Repository',
      },
    },
    config = function()
      -- That makes sure that any opened buffer which is contained in a git
      -- repo will be tracked.
      -- TODO: On directory changes it doesn's work. Also in opening a new buffer.
      --  Repository should be updated in Lazygit as well. I used LazyGitCurrentFile
      --  To load new repository.
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Load repository path',
        pattern = '*',
        callback = function()
          require('lazygit.utils').project_root_dir()
        end,
      })
    end,
  },
}
