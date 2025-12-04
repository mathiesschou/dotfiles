return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Add nil_ls (Nix LSP) to servers
      opts.servers = opts.servers or {}
      opts.servers.nil_ls = {
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixpkgs-fmt" },
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Add nixpkgs-fmt for Nix files
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.nix = { "nixpkgs-fmt" }
    end,
  },
}
