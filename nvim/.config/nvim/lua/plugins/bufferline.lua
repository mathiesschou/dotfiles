return {
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons', -- Icons for buffers
		config = function()
			require('bufferline').setup({
				options = {
					numbers = "none", -- No numbering
					close_command = "bdelete! %d", -- Close buffer
					indicator = {
						style = "icon", -- 
						icon = "▎",
					},
					modified_icon = "●",
					close_icon = "",
					left_trunc_marker = "",
					right_trunc_marker = "",
					max_name_length = 18,
					max_prefix_length = 15,
					tab_size = 18,
					show_buffer_close_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,
					persist_buffer_sort = true,
					separator_style = "slant", -- "slant", "thick", "thin"
					enforce_regular_tabs = false,
					always_show_bufferline = true,
				},
			})

			-- Keymaps for buffer navigation in normal mode
			vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true, desc = "Next Buffer" })
			vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true, desc = "Previous Buffer" })
		end,
	}
}

