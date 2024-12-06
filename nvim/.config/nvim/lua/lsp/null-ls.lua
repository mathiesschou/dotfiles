return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- ESLint diagnostics
                null_ls.builtins.diagnostics.eslint_d,
                -- Prettier formatting
                null_ls.builtins.formatting.prettier.with({
                    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "json" },
                }),
            },
        })
    end
}
