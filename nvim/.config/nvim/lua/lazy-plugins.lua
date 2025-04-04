require("lazy").setup({
  "tpope/vim-sleuth",
  require("plugins/catppuccin"),
  require("plugins/neo-tree"),
  require("plugins/treesitter"),
  require("plugins/telescope"),
  require("plugins/autopairs"),
  require("plugins/todo-comments"),
  require("plugins/indentline"),
  require("plugins/neoscroll"),
  require("plugins.vim-tmux"),
  -- LSP
  require("plugins/lspconfig"),
  require("plugins/cmp"),
  require("plugins/comform"),
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
