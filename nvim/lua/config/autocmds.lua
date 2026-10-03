-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Hard-wrap prose at 100 columns while typing (textwidth + formatoptions 't')
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("edgar_wrap_100", { clear = true }),
  pattern = {
    "text",
    "plaintex",
    "tex",
    "typst",
    "markdown",
    "json",
    "jsonc",
    "json5",
    "gitcommit",
    "rst",
    "asciidoc",
    "norg",
  },
  callback = function()
    vim.opt_local.textwidth = 100
    -- LazyVim's default formatoptions includes 'l' ("Long lines are not broken in
    -- insert mode"), which silently disables wrapping on any line that is already
    -- longer than 'textwidth' when you enter insert mode. Drop it here.
    vim.opt_local.formatoptions:remove("l")
    vim.opt_local.formatoptions:append("tc")
    vim.opt_local.colorcolumn = "100"
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "morning", "edgar-morning" },
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#ffffff", bg = "#000000" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    vim.treesitter.query.set("markdown_inline", "injections", "")
  end,
})
