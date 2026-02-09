-- Typst: 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Disable spell checking
vim.opt_local.spell = false
vim.opt_local.spelllang = "none"

-- Conceal markup for cleaner writing
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""

-- Typst-specific surround overrides (bold is single * in Typst)
local ok, surround = pcall(require, "nvim-surround")
if ok then
  surround.buffer_setup({
    surrounds = {
      -- Bold: *text*
      ["*"] = {
        add = { "*", "*" },
        find = "%*(.-)%*",
        delete = "^(%*)().-()(%*)$",
      },
      -- Math: $expr$
      ["$"] = {
        add = { "$", "$" },
        find = "%$(.-)%$",
        delete = "^(%$)().-()(%$)$",
      },
      -- Display math: $ expr $
      ["E"] = {
        add = { { "$ " }, { " $" } },
        find = "%$%s.-%s%$",
        delete = "^(%$%s)().-()(%s%$)$",
      },
      -- Content block: [text]
      ["["] = {
        add = { "[", "]" },
        find = "%b[]",
        delete = "^(%[)().-()(%])$",
      },
      -- Function call: #func(text)
      ["#"] = {
        add = function()
          local func = vim.fn.input("Function: ")
          return { { "#" .. func .. "(" }, { ")" } }
        end,
        find = "#%w+%b()",
        delete = "^(#%w+%()().-()(%))$",
      },
    },
  })
end

-- Auto-close $ in Typst
local ap_ok, npairs = pcall(require, "nvim-autopairs")
if ap_ok then
  local Rule = require("nvim-autopairs.rule")
  npairs.add_rules({
    Rule("$", "$", "typst"),
  })
end
