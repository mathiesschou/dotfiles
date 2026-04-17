return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("kanagawa-dragon")
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
  end,
}
