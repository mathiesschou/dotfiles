return {
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require('harpoon')
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            -- Keybindings
            vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Tilføj fil til Harpoon" })
            vim.keymap.set("n", "<leader>r", ui.toggle_quick_menu, { desc = "Åbn Harpoon menu" })

            -- Quick navigation between files 
            vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Åbn Harpoon fil 1" })
            vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Åbn Harpoon fil 2" })
            vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Åbn Harpoon fil 3" })
            vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Åbn Harpoon fil 4" })
        end
    }
}

