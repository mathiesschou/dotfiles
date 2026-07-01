return {
  "mikavilpas/yazi.nvim",
  keys = {
    { "<leader>y", "<cmd>Yazi<cr>",        desc = "Yazi (current file)" },
    { "<leader>Y", "<cmd>Yazi cwd<cr>",    desc = "Yazi (cwd)" },
  },
  opts = {
    open_for_directories = true,
  },
}
