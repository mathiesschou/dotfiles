return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list (Trouble)" },
    },
  },
}
