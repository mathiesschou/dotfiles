return {
	{
		'hrsh7th/cmp-nvim-lsp',
		lazy = false,
		{
			'hrsh7th/nvim-cmp',
			lazy = false,
			dependencies = {
				'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
				'L3MON4D3/LuaSnip', -- Snippets plugin
				'saadparwaiz1/cmp_luasnip', -- LuaSnip integration for nvim-cmp
			},
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body) -- Snippet luasnip integration
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<Tab>"] = cmp.mapping.select_next_item(), -- Tab for choosing
						["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift+tab for choosing backwards
						["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm with enter
					}),
					sources = {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "buffer" },
						{ name = "path" },
					},
				})
			end,
		},
	},
}
