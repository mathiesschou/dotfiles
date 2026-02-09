return {
	{
		"kaarmu/typst.vim",
		ft = "typst",
		lazy = false,
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {
			dependencies_bin = {
				["tinymist"] = "tinymist",
				["websocat"] = "websocat",
			},
			follow_cursor = true,
		},
		keys = {
			{ "<leader>tp", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "Toggle Typst Preview" },
			{ "<leader>ts", "<cmd>TypstPreviewSyncCursor<cr>", ft = "typst", desc = "Sync Cursor" },
		},
	},
}
