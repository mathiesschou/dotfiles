return {
  "folke/zen-mode.nvim",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
  },
  opts = {
    plugins = {
      tmux = { enabled = true }, -- hide tmux statusline
    },
  },
}
