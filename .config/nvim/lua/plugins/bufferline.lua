return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
      { "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete buffer" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "neo-tree", text = "Neo-tree", separator = true },
        },
      },
    },
  },
}
