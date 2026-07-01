return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "buffers" },
        { "<leader>f", group = "find (telescope)" },
        { "<leader>l", group = "lsp" },
        { "<leader>x", group = "diagnostics (trouble)" },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer keymaps (which-key)",
      },
    },
  },
}
