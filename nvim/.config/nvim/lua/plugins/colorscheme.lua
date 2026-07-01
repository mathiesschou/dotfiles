return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
      local function set_editor_highlights()
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313640" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5c07b", bold = true })
        vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#313640" })
      end

      vim.cmd.colorscheme("onedark")
      set_editor_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("UserEditorHighlights", { clear = true }),
        callback = set_editor_highlights,
      })
    end,
  },
}
