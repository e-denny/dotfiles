-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.tex_conceal = ""

-- Soft-wrap long lines at word boundaries (LazyVim sets wrap = false)
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Keep auto-wrap enabled in insert mode; 'textwidth' is set per filetype below
vim.opt.formatoptions:append("tc")
