-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>r", function()
  local keys = { h = "<C-w><", l = "<C-w>>", j = "<C-w>+", k = "<C-w>-" }
  while true do
    local ok, key = pcall(vim.fn.getcharstr)
    if not ok or key == "q" or key == "\27" then break end
    local cmd = keys[key]
    if cmd then vim.cmd("normal! " .. cmd) end
  end
end, { desc = "Resize window mode" })
