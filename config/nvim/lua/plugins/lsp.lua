return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "ts_ls",
        "pyright",
      },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
}
