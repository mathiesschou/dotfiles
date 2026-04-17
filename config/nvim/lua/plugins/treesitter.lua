return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua", "vim", "vimdoc",
      "rust", "typescript", "javascript", "tsx",
      "python", "c_sharp",
      "json", "yaml", "toml", "markdown",
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
