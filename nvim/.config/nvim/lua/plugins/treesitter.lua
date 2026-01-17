return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Install required parsers
      require("nvim-treesitter").install({
        "lua",
        "c",
        "cpp",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "html_tags",
        "css",
        "json",
        "python",
        "rust",
        "nix",
        "latex",
        "typst",
        "svelte",
        "bash",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
      })

      -- Enable highlighting per buffer via autocmd
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
