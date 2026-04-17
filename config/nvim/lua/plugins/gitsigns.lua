return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end
      map("]h", gs.next_hunk, "Next hunk")
      map("[h", gs.prev_hunk, "Prev hunk")
      map("<leader>hs", gs.stage_hunk, "Stage hunk")
      map("<leader>hr", gs.reset_hunk, "Reset hunk")
      map("<leader>hp", gs.preview_hunk, "Preview hunk")
      map("<leader>hb", gs.blame_line, "Blame line")
    end,
  },
}
