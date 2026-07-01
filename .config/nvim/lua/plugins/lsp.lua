return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", config = true },
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {}, -- install servers yourself via :Mason
        automatic_enable = false, -- keep LSP off until :LspToggle
      })

      -- Diagnostics display
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      })

      local servers_by_filetype = {
        zig = { "zls" },
        zir = { "zls" },
      }

      local function enable_lsp_for_buffer(bufnr)
        local filetype = vim.bo[bufnr].filetype
        local enabled = false

        if filetype == "cs" or filetype == "razor" then
          require("lazy").load({ plugins = { "roslyn.nvim" } })
          vim.lsp.enable("roslyn")
          enabled = true
        end

        for _, name in ipairs(servers_by_filetype[filetype] or {}) do
          vim.lsp.enable(name)
          enabled = true
        end

        for name in pairs(vim.lsp.config._configs or {}) do
          local config = vim.lsp.config[name]
          local filetypes = config and config.filetypes
          if filetypes and vim.tbl_contains(filetypes, filetype) then
            vim.lsp.enable(name)
            enabled = true
          end
        end

        return enabled
      end

      local function toggle_lsp()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })

        if #clients > 0 then
          for _, client in ipairs(clients) do
            vim.lsp.enable(client.name, false)
            client:stop(true)
          end
          vim.diagnostic.enable(false, { bufnr = bufnr })
          vim.notify("LSP off for current buffer", vim.log.levels.INFO)
          return
        end

        vim.diagnostic.enable(true, { bufnr = bufnr })
        if enable_lsp_for_buffer(bufnr) then
          vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr, modeline = false })
          vim.notify("LSP on for current buffer", vim.log.levels.INFO)
        else
          vim.notify("No LSP config found for this filetype", vim.log.levels.WARN)
        end
      end

      vim.api.nvim_create_user_command("LspToggle", toggle_lsp, {
        desc = "Toggle LSP for current buffer",
      })
      vim.keymap.set("n", "<leader>lt", toggle_lsp, { desc = "LSP: Toggle" })

      -- Keymaps active only in buffers with an attached LSP.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })
    end,
  },
}
