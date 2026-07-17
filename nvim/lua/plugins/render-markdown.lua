return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      bullet = {
        icons = { "●", "○", "◆", "◇" },
        right_pad = 1,
      },
      quote = {
        repeat_linebreak = true,
      },
      win_options = {
        showbreak = {
          default = "",
          rendered = "  ",
        },
        breakindent = {
          default = false,
          rendered = true,
        },
        breakindentopt = {
          default = "",
          rendered = "",
        },
      },
    },
  },
}
