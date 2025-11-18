return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "ts_ls",
          "rust_analyzer",
          "html",
          "cssls",
          "jsonls",
          "pyright",
        },
      })

      -- Use vim.lsp.config instead of lspconfig
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
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
      })

      -- Configure C/C++
      vim.lsp.config("clangd", {
        cmd = { "clangd" },
        root_markers = { "compile_commands.json", ".git", "Makefile" },
      })

      -- Configure TypeScript/JavaScript
      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        root_markers = { "package.json", "tsconfig.json", ".git" },
      })

      -- Configure Rust
      vim.lsp.config("rust_analyzer", {
        cmd = { "rust-analyzer" },
        root_markers = { "Cargo.toml", ".git" },
      })

      -- Configure HTML
      vim.lsp.config("html", {
        cmd = { "vscode-html-language-server", "--stdio" },
        root_markers = { ".git" },
      })

      -- Configure CSS
      vim.lsp.config("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        root_markers = { ".git" },
      })

      -- Configure JSON
      vim.lsp.config("jsonls", {
        cmd = { "vscode-json-language-server", "--stdio" },
        root_markers = { ".git" },
      })

      -- Configure Python
      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })

      -- Auto-start LSP on relevant filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function(args)
          vim.lsp.start({ name = "lua_ls", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function(args)
          vim.lsp.start({ name = "clangd", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        callback = function(args)
          vim.lsp.start({ name = "ts_ls", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(args)
          vim.lsp.start({ name = "rust_analyzer", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "html",
        callback = function(args)
          vim.lsp.start({ name = "html", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "css",
        callback = function(args)
          vim.lsp.start({ name = "cssls", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "json",
        callback = function(args)
          vim.lsp.start({ name = "jsonls", bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          vim.lsp.start({ name = "pyright", bufnr = args.buf })
        end,
      })

      -- Keymaps when LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}
