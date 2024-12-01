return {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        local logo = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]]

        dashboard.section.header.val = vim.split(logo, "\n")

        -- Buttons 
        dashboard.section.buttons.val = {
            dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
            dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
            dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
            dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
        }

        -- Footer text
        dashboard.section.footer.val = { "Welcome to Neovim Mathies!" }

        -- Define layout
        dashboard.config.layout = {
            { type = "padding", val = 1 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }

		-- Setup alpha 
        alpha.setup(dashboard.config)
    end,
}

