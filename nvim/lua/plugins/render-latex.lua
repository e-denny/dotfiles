return {
  {
    "techwizrd/render-latex.nvim",
    dependencies = { "3rd/image.nvim" },
    opts = {
      render = {
        preset = "match_text",
        scale = 1.05,
        inline = "conceal",
        inline_symbols = true,
        live_preview = true,
        hide_on_cmdline = false,
      },
    },
    ft = { "markdown", "tex" },
  },
}
