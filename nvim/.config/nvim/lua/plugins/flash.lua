return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<CR>", mode = "n", function() require("flash").jump() end, desc = "Flash" },
    },
  },
}
