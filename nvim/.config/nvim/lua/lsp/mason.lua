return {
	{
		-- Mason lsp manager 
    	"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end
	},
	{
		-- Connectes lsp with mason
    	"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		}
	},
}
