return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      -- Lua (lua_ls)
      lua = { "stylua" },

      -- C/C++ (clangd)
      c = { "clang_format" },
      cpp = { "clang_format" },

      -- TypeScript/JavaScript (ts_ls)
      javascript = { "prettier", "prettierd" },
      typescript = { "prettier", "prettierd" },
      javascriptreact = { "prettier", "prettierd" },
      typescriptreact = { "prettier", "prettierd" },

      -- Rust (rust_analyzer)
      rust = { "rustfmt" },

      -- HTML (html)
      html = { "prettier", "prettierd" },

      -- CSS (cssls)
      css = { "prettier", "prettierd" },

      -- JSON (jsonls)
      json = { "prettier", "prettierd" },

      -- Python (pyright)
      python = { "isort", "black" },

      -- Nix (nil_ls)
      nix = { "nixpkgs-fmt" },

      -- Svelte
      svelte = { "prettier", "prettierd" },

      -- Extra
      markdown = { "prettier", "prettierd" },
      yaml = { "prettier", "prettierd" },
    },
    formatters = {
      prettier = {
        prepend_args = { "--print-width", "80" },
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
