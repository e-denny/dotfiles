return {
  "junegunn/vim-easy-align",
  lazy = false,
  init = function()
    vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Easy Align" })
  end,
}
