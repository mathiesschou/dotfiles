return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          -- nvim-treesitter main branch dropped ft_to_lang; disable ts in
          -- the previewer to avoid the crash, fall back to regex syntax.
          preview = { treesitter = false },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}
