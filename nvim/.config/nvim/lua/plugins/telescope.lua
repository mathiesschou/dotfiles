return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local telescope = require('telescope')
		local builtin = require('telescope.builtin')

		telescope.setup {
			defaults = {
				-- Ignore files 
				file_ignore_patterns = { 
					".*%.aux", 
					".*%.log", 
					".*%.fls", 
					".*%.fdb_latexmk", 
					".*%.synctex%.gz", 
					".*%.out", 
					".*%.toc", 
					".*%.pdf"
				},
				layout_config = {
					prompt_position = "top",
				},
				{
					-- Find characters
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case"
					},
				},
				pickers = {
					find_files = {
						hidden = true, -- Include hidden files 
					},
					live_grep = {
						only_sort_text = true, -- Optimize live-grep
					},
			},
			},
		}
		-- Keymaps
		vim.keymap.set('n', '<leader>f', builtin.find_files, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>g', builtin.live_grep, { noremap = true, silent = true })
		-- For themes 
		vim.keymap.set('n', '<leader>th', function()
			builtin.colorscheme({ enable_preview = true })
		end, { noremap = true, silent = true, desc = "Choose Colorscheme" })
	end
}
