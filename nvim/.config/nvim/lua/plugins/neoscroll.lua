return {
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      -- Animate these scroll mappings (Ctrl-u / Ctrl-d included by default).
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      easing = "sine",
    },
  },
}
