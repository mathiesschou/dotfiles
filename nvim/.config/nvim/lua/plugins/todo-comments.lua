return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>tn", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "<leader>tp", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Search todos" },
    },
  },
}
