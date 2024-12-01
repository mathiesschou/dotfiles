return {
	"xiyaowong/transparent.nvim",
	config = function()
		require("transparent").setup({
			groups = { -- Standard
				"Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
				"Statement", "PreProc", "Type", "Underlined", "Todo", "String",
				"Function", "Conditional", "Repeat", "Operator", "Structure", "LineNr",
				"NonText", "SignColumn", "CursorLine", "CursorLineNr", "StatusLine",
				"StatusLineNC", "EndOfBuffer",
			},
			-- Extra plugins that needs transparency
			extra_groups = {
				"TelescopeNormal",
				"TelescopeBorder",
				"TelescopePromptBorder",
				"TelescopeResultsBorder",
				"TelescopePreviewBorder",
				"NvimTreeNormal",
				"NvimTreeEndOfBuffer",
				"NvimTreeWinSeparator",
				"BufferLineFill",
				"BufferLineBackground",
				"BufferLineTab",
				"BufferLineTabSelected",
				"BufferLineTabClose",
				"BufferLineIndicatorSelected",
				"BufferLineBufferSelected",
				"BufferLineBufferVisible",
				"DressingInput",
				"DressingSelect",
			},
		})

		-- Plugins
		require("transparent").clear_prefix("NvimTree")
		require("transparent").clear_prefix("Telescope")
		require("transparent").clear_prefix("BufferLine")
		require("transparent").clear_prefix("Dressing")

		-- Keymap for toggleing transparency
		vim.keymap.set("n", "<leader>tt", ":TransparentToggle<CR>", { noremap = true, silent = true, desc = "Toggle transparency" })
	end,
}

