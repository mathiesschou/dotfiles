local keys = {
	{ "<leader>tp", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "Toggle Typst Preview" },
	{ "<leader>ts", "<cmd>TypstPreviewSyncCursor<cr>", ft = "typst", desc = "Sync Cursor" },
}

-- Add Zathura preview keybinding for thinkpad-p50 only
local hostname = vim.fn.hostname()
if hostname == "thinkpad-p50" then
	table.insert(keys, {
		"<leader>tz",
		function()
			local file = vim.fn.expand("%:p")
			local pdf = vim.fn.expand("%:p:r") .. ".pdf"
			vim.cmd("silent !typst compile " .. vim.fn.shellescape(file))
			vim.cmd("silent !zathura " .. vim.fn.shellescape(pdf) .. " &")
			vim.cmd("redraw!")
		end,
		ft = "typst",
		desc = "Open PDF in Zathura",
	})
end

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
		keys = keys,
	},
}
