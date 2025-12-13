-- LaTeX: 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Enable spell checking for LaTeX
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us,da"

-- Keymaps for LaTeX
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

-- Forward search (sync from nvim to PDF)
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.execute_command({
    command = "textDocument/forwardSearch",
    arguments = { vim.uri_from_bufnr(0) },
  })
end, vim.tbl_extend("force", opts, { desc = "Forward search" }))

-- Build PDF
vim.keymap.set("n", "<leader>lb", function()
  vim.lsp.buf.execute_command({
    command = "textDocument/build",
    arguments = { vim.uri_from_bufnr(0) },
  })
end, vim.tbl_extend("force", opts, { desc = "Build PDF" }))
