return {
  {
    "techwizrd/render-latex.nvim",
    dependencies = { "3rd/image.nvim" },
    opts = {
      render = {
        preset = "match_text",
        inline = "conceal",
        inline_symbols = true,
        live_preview = true,
        hide_on_cmdline = false,
      },
    },
    ft = { "markdown", "tex" },
  },
}
