return {
	{
		-- Markdown Preview Plugin
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		build = "cd app && npm install",
		build = "cd app && npm install && git restore .",
		build = function()
			local install_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
			vim.cmd("silent !cd " .. install_path .. " && npm install && git restore .")
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_close = 0
		end,
	},

    -- Twilight Plugin
    {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup({
                dimming = {
                    alpha = 0.25,
                },
                context = 10,
                treesitter = true,
                expand = { "function", "method", "table", "if_statement" },
            })
        end,
    },
}


