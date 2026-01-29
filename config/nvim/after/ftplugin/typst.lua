-- Typst: 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Disable spell checking
vim.opt_local.spell = false
vim.opt_local.spelllang = "none"

-- Keymaps for Typst
local opts = { buffer = true, silent = true }

-- Preview PDF with sioyek
vim.keymap.set("n", "<leader>lp", function()
  local pdf = vim.fn.expand("%:r") .. ".pdf"
  if vim.fn.filereadable(pdf) == 1 then
    vim.fn.jobstart({ "sioyek", "--reuse-window", pdf }, { detach = true })
  else
    vim.notify("PDF not found: " .. pdf, vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Preview PDF" }))

