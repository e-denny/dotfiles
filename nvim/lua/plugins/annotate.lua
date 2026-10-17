return {
  {
    "e-denny/annotate.nvim",
    branch = "main",
    -- Review mode is explicit: opening a Markdown file must stay ordinary
    -- editing, with no sidecar and no split. Load on demand only — from
    -- `:Annotate notes.md`, or from Pi's `/annotate` command, which sets
    -- ANNOTATE_FILE and calls require("annotate").setup().
    cmd = "Annotate",
    module = "annotate",
  },
}
