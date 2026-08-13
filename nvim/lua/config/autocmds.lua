-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function apply_edgar_morning_overrides()
  vim.api.nvim_set_hl(0, "Cursor", { fg = "#ffffff", bg = "#000000" })
  vim.api.nvim_set_hl(0, "ObsidianRefText", { fg = "#9f75bb", underline = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "morning", "edgar-morning" },
  callback = apply_edgar_morning_overrides,
})

-- Re-apply after obsidian installs its highlight groups on buffer enter
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
    if vim.g.colors_name == "edgar-morning" then
      vim.api.nvim_set_hl(0, "ObsidianRefText", { fg = "#9f75bb", underline = true })
    end
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
