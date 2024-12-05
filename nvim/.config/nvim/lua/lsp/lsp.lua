return { 
	"neovim/nvim-lspconfig",
	lazy= false,
	config = function()
		vim.opt.signcolumn = 'yes'

		local lspconfig_defaults = require('lspconfig').util.default_config
		lspconfig_defaults.capabilities = vim.tbl_deep_extend(
			'force',
		lspconfig_defaults.capabilities,
		require('cmp_nvim_lsp').default_capabilities()
		)

		-- Settings when lsp registers a language
		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = {buffer = event.buf}
				
				-- Keymaps for LSP 
				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
			end,
		})

		local lspconfig = require("lspconfig")
		local mason = require("mason")
		mason.setup()

		-----------------
		-- LSP servers --
		-----------------

		-- Python
		lspconfig.basedpyright.setup({})

		-- Latex
		lspconfig.digestif.setup({})

		-- TypeScript Server
        lspconfig.ts_ls.setup({
            on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
            end,
        })

		-- JavaScript/Typescript lining
        lspconfig.eslint.setup({
            on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = true
            end,
        })

		-- Tailwind for CSS
        lspconfig.tailwindcss.setup({})

		---------------------
		-- End LSP servers --
		---------------------

		local cmp = require('cmp')
		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- Use Luasnip for cmp 
				end,
			},
			-- Keymaps for cmp
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' }, 
				{ name = 'buffer' },  
				{ name = 'path' },    
			}),
		})
	end,
}
