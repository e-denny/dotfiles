-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>pv", function()
  local file = vim.fn.expand("%:p")
  local vaults = {
    { name = "obsidian-vault", path = "/home/edgar/Documents/Obsidian Vault" },
    { name = "llm-wiki",       path = "/home/edgar/Documents/llm-wiki" },
  }
  for _, vault in ipairs(vaults) do
    if file:sub(1, #vault.path) == vault.path then
      local rel = file:sub(#vault.path + 2)
      local uri = "obsidian://open?vault=" .. vault.name .. "&file=" .. vim.uri_encode(rel)
      vim.fn.jobstart({ "xdg-open", uri }, { detach = true })
      return
    end
  end
  vim.notify("File is not inside a known Obsidian vault", vim.log.levels.WARN)
end, { desc = "Preview in Obsidian" })

vim.keymap.set("n", "<leader>r", function()
  local keys = { h = "<C-w><", l = "<C-w>>", j = "<C-w>+", k = "<C-w>-" }
  while true do
    local ok, key = pcall(vim.fn.getcharstr)
    if not ok or key == "q" or key == "\27" then break end
    local cmd = keys[key]
    if cmd then vim.cmd("normal! " .. cmd) end
  end
end, { desc = "Resize window mode" })
