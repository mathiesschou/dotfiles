return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("gruvbox")
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
  end,
}
