-- NOTE: Set <space> as the leader key
-- See `:help mapleader`
--  WARNING: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- NOTE: Move highlighted lines with auto indentation
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move Up' })

-- NOTE: Append next line to the current line with space (keeps cursor position)
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Append Next Line' })

-- NOTE: Keep cursor in the middle of screen when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll [D]own' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll [U]p' })

-- NOTE: Keep search term in the middle of screen always
vim.keymap.set('n', 'n', 'nzzzv', { desc = '[N]ext Occurrence' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous Occurrence' })

-- NOTE: Pasting or deleting to void register
vim.keymap.set('x', '<leader>kp', '"_dP', { desc = 'Preserved [P]aste' })
vim.keymap.set('n', '<leader>kd', '"_d', { desc = 'Preserved [D]elete' })
vim.keymap.set('v', '<leader>kd', '"_d', { desc = 'Preserved [D]elete' })

-- NOTE: Replace word under the cursor
vim.keymap.set('n', '<leader>ks', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[S]ubstitute Current Word' })

-- NOTE: Separate Vim clipboard and system clipboard
-- TODO: Currently the clipboards are synced
vim.keymap.set('n', '<leader>ky', '"+y', { desc = '[Y]ank to System Clipboard' })
vim.keymap.set('v', '<leader>ky', '"+y', { desc = '[Y]ank to System Clipboard' })
vim.keymap.set('n', '<leader>kY', '"+Y', { desc = '[Y]ank Rest to System Clipboard' })
