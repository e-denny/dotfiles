return {
  {
    "e-denny/mdmath.nvim",
    branch = "inline-baseline-sizing",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "markdown",
    opts = {
      filetypes = { "markdown" },
      foreground = "Normal",
      anticonceal = true,
      hide_on_insert = true,
      dynamic = true,
      dynamic_scale = 0.7,
      baseline_frac = 0.783,
      inline_scale = 0.8,
    },
  },
}
