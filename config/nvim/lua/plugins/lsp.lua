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
        "sourcekit",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local servers = { "lua_ls", "rust_analyzer", "ts_ls", "pyright" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({})
      end
    end,
  },
}
