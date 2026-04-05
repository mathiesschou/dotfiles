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
      -- Read theme variant from file, default to mocha if file doesn't exist
      local variant_file = vim.fn.expand("~/.config/theme-variant")
      local flavour = "mocha"
      if vim.fn.filereadable(variant_file) == 1 then
        local variant = vim.fn.readfile(variant_file)[1]
        if variant == "latte" or variant == "mocha" or variant == "frappe" then
          flavour = variant
        end
      end

      return {
        flavour = flavour,
        -- transparent_background = true,
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
        -- custom_highlights = function(colors)
        --   return {
        --     -- Bufferline transparency
        --     BufferLineFill = { bg = "NONE" },
        --     BufferLineBackground = { fg = colors.subtext0, bg = "NONE" },
        --     BufferLineBufferSelected = { fg = colors.text, bg = "NONE", bold = true, italic = true },
        --     BufferLineBufferVisible = { fg = colors.subtext0, bg = "NONE" },
        --     BufferLineSeparator = { fg = colors.surface0, bg = "NONE" },
        --     BufferLineSeparatorSelected = { fg = colors.surface0, bg = "NONE" },
        --     BufferLineSeparatorVisible = { fg = colors.surface0, bg = "NONE" },
        --     BufferLineIndicatorSelected = { fg = colors.lavender, bg = "NONE" },
        --     BufferLineModified = { fg = colors.yellow, bg = "NONE" },
        --     BufferLineModifiedSelected = { fg = colors.yellow, bg = "NONE" },
        --     BufferLineModifiedVisible = { fg = colors.yellow, bg = "NONE" },
        --   }
        -- end,
      }
    end,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- -- Ensure full transparency for Ghostty opacity/blur
      -- local transparent_groups = {
      --   "Normal",
      --   "NormalFloat",
      --   "NormalNC",
      --   "SignColumn",
      --   -- Bufferline
      --   "BufferLineFill",
      --   "BufferLineBackground",
      --   "BufferLineTab",
      --   "BufferLineTabClose",
      --   "BufferLineTabSelected",
      --   "BufferLineSeparator",
      --   "BufferLineSeparatorVisible",
      --   "BufferLineSeparatorSelected",
      --   "BufferLineBufferSelected",
      --   "BufferLineBufferVisible",
      --   "BufferLineCloseButton",
      --   "BufferLineCloseButtonSelected",
      --   "BufferLineCloseButtonVisible",
      --   "BufferLineModified",
      --   "BufferLineModifiedSelected",
      --   "BufferLineModifiedVisible",
      --   "BufferLineDuplicate",
      --   "BufferLineDuplicateSelected",
      --   "BufferLineDuplicateVisible",
      --   "BufferLineIndicatorSelected",
      --   "BufferLineIndicatorVisible",
      --   "BufferLinePick",
      --   "BufferLinePickSelected",
      --   "BufferLinePickVisible",
      --   -- Neo-tree
      --   "NeoTreeNormal",
      --   "NeoTreeNormalNC",
      --   "NeoTreeEndOfBuffer",
      --   -- Telescope
      --   "TelescopeNormal",
      --   "TelescopeBorder",
      --   "TelescopePromptNormal",
      --   "TelescopePromptBorder",
      --   "TelescopeResultsNormal",
      --   "TelescopeResultsBorder",
      --   "TelescopePreviewNormal",
      --   "TelescopePreviewBorder",
      -- }
      --
      -- for _, group in ipairs(transparent_groups) do
      --   vim.api.nvim_set_hl(0, group, { bg = "NONE" })
      -- end

      -- Auto-reload when theme file changes
      local variant_file = vim.fn.expand("~/.config/theme-variant")
      local last_variant = nil

      local function reload_theme()
        if vim.fn.filereadable(variant_file) == 1 then
          local lines = vim.fn.readfile(variant_file)
          if #lines > 0 then
            local variant = lines[1]
            if variant ~= last_variant then
              last_variant = variant
              local flavour = variant
              if flavour ~= "latte" and flavour ~= "mocha" and flavour ~= "frappe" then
                flavour = "mocha"  -- fallback
              end
              require("catppuccin").setup({ flavour = flavour })
              vim.cmd.colorscheme("catppuccin")

              -- -- Reapply transparency
              -- local transparent_groups = {
              --   "Normal",
              --   "NormalFloat",
              --   "NormalNC",
              --   "SignColumn",
              --   "BufferLineFill",
              --   "BufferLineBackground",
              --   "BufferLineTab",
              --   "BufferLineTabClose",
              --   "BufferLineTabSelected",
              --   "BufferLineSeparator",
              --   "BufferLineSeparatorVisible",
              --   "BufferLineSeparatorSelected",
              --   "BufferLineBufferSelected",
              --   "BufferLineBufferVisible",
              --   "BufferLineCloseButton",
              --   "BufferLineCloseButtonSelected",
              --   "BufferLineCloseButtonVisible",
              --   "BufferLineModified",
              --   "BufferLineModifiedSelected",
              --   "BufferLineModifiedVisible",
              --   "BufferLineDuplicate",
              --   "BufferLineDuplicateSelected",
              --   "BufferLineDuplicateVisible",
              --   "BufferLineIndicatorSelected",
              --   "BufferLineIndicatorVisible",
              --   "BufferLinePick",
              --   "BufferLinePickSelected",
              --   "BufferLinePickVisible",
              --   "NeoTreeNormal",
              --   "NeoTreeNormalNC",
              --   "NeoTreeEndOfBuffer",
              --   "TelescopeNormal",
              --   "TelescopeBorder",
              --   "TelescopePromptNormal",
              --   "TelescopePromptBorder",
              --   "TelescopeResultsNormal",
              --   "TelescopeResultsBorder",
              --   "TelescopePreviewNormal",
              --   "TelescopePreviewBorder",
              -- }
              --
              -- for _, group in ipairs(transparent_groups) do
              --   vim.api.nvim_set_hl(0, group, { bg = "NONE" })
              -- end
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
