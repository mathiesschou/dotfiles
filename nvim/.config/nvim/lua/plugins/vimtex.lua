return {
    "lervag/vimtex",
    lazy = false,
    config = function()
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
            build_dir = "",
            executable = "latexmk", 
            options = {
                "-pdf", 
                "-pdflatex=lualatex", 
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
            },
        }
    end,
}

