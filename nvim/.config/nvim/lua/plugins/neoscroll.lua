return {
    "karb94/neoscroll.nvim",
    config = function()
        require("neoscroll").setup({
            mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
                '<C-u>', '<C-d>',
                'zt', 'zz', 'zb',
            },
            hide_cursor = true,          -- Hide cursor while scrolling
            stop_eof = true,             -- Stop at <EOF> when scrolling downwards
            respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing = "quadratic",        -- Default easing function (options: "linear", "quadratic", "cubic", etc.)
            performance_mode = false,    -- Disable "Performance Mode" on all buffers
        })
 
        local neoscroll = require("neoscroll")

		-- Keymaps
        vim.keymap.set("n", "<C-u>", function()
            neoscroll.scroll(-vim.wo.scroll, { easing = "quadratic", duration = 100 })
        end, { silent = true, desc = "Scroll up" })

        vim.keymap.set("n", "<C-d>", function()
            neoscroll.scroll(vim.wo.scroll, { easing = "quadratic", duration = 100 })
        end, { silent = true, desc = "Scroll down" })
   end,
}

