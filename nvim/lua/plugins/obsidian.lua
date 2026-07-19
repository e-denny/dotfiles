return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      log_level = vim.log.levels.ERROR,
      workspaces = {
        {
          name = "obsidian-vault",
          path = "/home/edgar/Documents/Obsidian Vault",
        },
        {
          name = "llm-wiki",
          path = "/home/edgar/Documents/llm-wiki",
        },
      },
      -- Use wikilinks by default (Obsidian style)
      preferred_link_style = "wiki",
      -- Follow wikilinks with gf
      follow_url_func = function(url)
        vim.fn.jobstart({ "xdg-open", url })
      end,
    },
  },
}
