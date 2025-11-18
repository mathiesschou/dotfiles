return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Keymaps when LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

          -- Diagnostic keymaps
          vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
        end,
      })

      -- Configure LSP servers using the new API
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        clangd = {},
        ts_ls = {},
        rust_analyzer = {},
        html = {},
        cssls = {},
        jsonls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      }

      -- Setup all servers
      for server, config in pairs(servers) do
        vim.lsp.config[server] = config
        vim.lsp.enable(server)
      end
    end,
  },
}
