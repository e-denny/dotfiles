return {
  {
    "e-denny/mdmath.nvim",
    branch = "main",
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
      inline_scale = 0.8,
      -- Open the image/attachment link under the cursor with `gx`
      -- (Obsidian ![[...]] / [[...svg|...]] or markdown ![...](...)).
      open_image_key = "gx",
      -- Toggle automatic in-place image previews on/off.
      toggle_images_key = "<leader>ti",
    },
  },
}
