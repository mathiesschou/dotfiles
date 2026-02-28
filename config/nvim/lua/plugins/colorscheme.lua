return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "", -- "hard", "soft" or empty
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function()
      -- Read theme from file, default to mocha if file doesn't exist
      local theme_file = vim.fn.expand("~/.config/theme-mode")
      local flavour = "mocha"
      if vim.fn.filereadable(theme_file) == 1 then
        local theme = vim.fn.readfile(theme_file)[1]
        if theme == "light" then
          flavour = "latte"
        end
      end

      return {
        flavour = flavour,
        transparent_background = false,
        integrations = {
          bufferline = true,
          telescope = true,
          treesitter = true,
          which_key = true,
          flash = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Auto-reload when theme file changes
      local theme_file = vim.fn.expand("~/.config/theme-mode")
      local last_theme = nil

      local function reload_theme()
        if vim.fn.filereadable(theme_file) == 1 then
          local lines = vim.fn.readfile(theme_file)
          if #lines > 0 then
            local theme = lines[1]
            if theme ~= last_theme then
              last_theme = theme
              local flavour = theme == "light" and "latte" or "mocha"
              require("catppuccin").setup({ flavour = flavour })
              vim.cmd.colorscheme("catppuccin")
            end
          end
        end
      end

      -- Check for theme changes every 2 seconds
      local timer = vim.loop.new_timer()
      timer:start(0, 2000, vim.schedule_wrap(reload_theme))
    end,
  },
  {
    "ishan9299/nvim-solarized-lua",
    lazy = true,
    priority = 1000,
  },
}
