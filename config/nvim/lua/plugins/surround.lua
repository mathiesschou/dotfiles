return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        surrounds = {
          -- Markdown bold: **text**
          ["*"] = {
            add = { "**", "**" },
            find = "%*%*.-%*%*",
            delete = "^(%*%*)().-()(%*%*)$",
          },
          -- Markdown italic: _text_
          ["_"] = {
            add = { "_", "_" },
            find = "_.-_",
            delete = "^(_)().-()(_)$",
          },
          -- Markdown inline code: `code`
          ["`"] = {
            add = { "`", "`" },
            find = "`.-`",
            delete = "^(`)().-()(`)$",
          },
          -- Markdown code block: ```code```
          ["c"] = {
            add = function()
              local lang = vim.fn.input("Language: ")
              return { { "```" .. lang, "" }, { "", "```" } }
            end,
            find = "```.-```",
            delete = "^(```%w*)().-()```$",
          },
          -- Markdown link: [text](url)
          ["l"] = {
            add = function()
              local url = vim.fn.input("URL: ")
              return { { "[", "](" .. url .. ")" }, { "", "" } }
            end,
            find = "%b[]%b()",
            delete = "^(%[)().-(%)(%))()$",
          },
        },
      })
    end,
  },
}
