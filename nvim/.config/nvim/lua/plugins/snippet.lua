return {
	{ 
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
	},
	{
		"SirVer/ultisnips",
		dependencies = { "honza/vim-snippets" },
		ft = { "tex", "markdown" },
		config = function()
			vim.g.UltiSnipsExpandTrigger = "<tab>" -- Expand snippet 
			vim.g.UltiSnipsJumpForwardTrigger = "<c-l>" -- Jump forward
			vim.g.UltiSnipsJumpBackwardTrigger = "<c-h>" -- Jump backwards
			vim.g.UltiSnipsSnippetDirectories = { "lua/snippets" } -- Path to snippets
		end,
	},
}
