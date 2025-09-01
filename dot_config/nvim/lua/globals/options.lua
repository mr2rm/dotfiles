-- NOTE: Spell checking
vim.opt.spell = true
vim.opt.spelllang = 'en_us'

-- NOTE: Indentation settings
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.shiftround = true -- Round indent to multiply of `shiftwidth`
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = 4 -- Size of a tab or a backspace (because of `expandtab`)
vim.opt.shiftwidth = 4 -- Size of a level of indent
vim.opt.breakindent = true -- Enable break indent for wrapped line
