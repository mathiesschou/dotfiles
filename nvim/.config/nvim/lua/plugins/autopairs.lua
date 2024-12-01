return {
	"windwp/nvim-autopairs",
	event = "InsertEnter", -- Load when in insert mode  
	config = function()
		require("nvim-autopairs").setup {
			check_ts = true, -- Check is TS is available 
			disable_filetype = { "TelescopePrompt" }, -- Deactivate in TelescopePrompt
		}
		-- Integrate with cmp
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on(
			"confirm_done",
			cmp_autopairs.on_confirm_done()
		)
	end
}

