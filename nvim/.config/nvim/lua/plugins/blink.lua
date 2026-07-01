return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- downloads a prebuilt fuzzy-matcher binary
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- <C-space> open, <C-y> accept, <C-n>/<C-p> select, <Tab> jump snippet.
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
