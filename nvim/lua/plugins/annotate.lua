return {
  {
    "e-denny/annotate.nvim",
    branch = "main",
    -- `setup()` only activates when Neovim was started with a `.md` argument,
    -- so loading on the markdown filetype is harmless for ordinary editing;
    -- it turns on review mode only for `nvim notes.md`.
    ft = "markdown",
    opts = {},
  },
}
