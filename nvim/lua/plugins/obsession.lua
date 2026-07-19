return {
  "tpope/vim-obsession",
  cmd = "Obsession",
  event = "VimEnter",
  config = function()
    -- Auto-start obsession when entering nvim, unless a session is already active
    -- or we're in a special buffer. Uses cwd-based Session.vim so each project
    -- gets its own file (safe across multiple nvim instances in different dirs).
    local group = vim.api.nvim_create_augroup("AutoObsession", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      nested = true,
      callback = function()
        -- Don't start if already tracking a session or launched with a session file
        if vim.v.this_session == "" then
          vim.cmd("Obsession")
        end
      end,
    })
  end,
}
