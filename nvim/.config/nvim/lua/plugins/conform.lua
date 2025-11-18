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
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },

      -- Rust (rust_analyzer)
      rust = { "rustfmt" },

      -- HTML (html)
      html = { { "prettierd", "prettier" } },

      -- CSS (cssls)
      css = { { "prettierd", "prettier" } },

      -- JSON (jsonls)
      json = { { "prettierd", "prettier" } },

      -- Python (pyright)
      python = { "isort", "black" },

      -- Extra
      markdown = { { "prettierd", "prettier" } },
      yaml = { { "prettierd", "prettier" } },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
