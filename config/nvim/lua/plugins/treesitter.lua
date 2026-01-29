return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "tsx",
          "rust",
          "c_sharp",
          "python",
          "lua",
          "c",
          "cpp",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "svelte",
          "typst",
        },
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
