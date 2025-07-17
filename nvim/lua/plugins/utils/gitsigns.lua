local LazyFile = require('utils').LazyFile

return {
  { -- Gitsigns
    'lewis6991/gitsigns.nvim',
    event = LazyFile,
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      on_attach = function(buffer)
        require('which-key').add {
          { '<leader>gh', desc = '[H]unk (Gitsigns)' },
        }

        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')

        -- Actions
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', '[S]tage Hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', '[R]eset Hunk')
        map('n', '<leader>ghS', gs.stage_buffer, '[S]tage Buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, '[U]ndo Stage Hunk')
        map('n', '<leader>ghR', gs.reset_buffer, '[R]eset Buffer')
        map('n', '<leader>ghp', gs.preview_hunk_inline, '[P]review Hunk Inline')
        map('n', '<leader>ghb', function()
          gs.blame_line { full = true }
        end, '[B]lame Line')
        map('n', '<leader>ghB', function()
          gs.blame()
        end, '[B]lame Buffer')
        map('n', '<leader>ghd', gs.diffthis, '[D]iff This')
        map('n', '<leader>ghD', function()
          gs.diffthis '~'
        end, '[D]iff This ~')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },
}
