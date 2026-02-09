local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Document template
  s(
    "template",
    fmt(
      [[
#set document(title: "{}", author: "{}")
#set page(paper: "{}", margin: ({}))
#set text(font: "{}", size: {})
#set par(justify: {})
#set heading(numbering: "{}")

{}]],
      {
        i(1, "Title"),
        i(2, "Author"),
        i(3, "a4"),
        i(4, "x: 2cm, y: 2cm"),
        i(5, "Linux Libertine"),
        i(6, "11pt"),
        i(7, "true"),
        i(8, "1.1"),
        i(0),
      }
    )
  ),

  -- Headings
  s("h1", fmt("= {}\n{}", { i(1, "Heading"), i(0) })),
  s("h2", fmt("== {}\n{}", { i(1, "Heading"), i(0) })),
  s("h3", fmt("=== {}\n{}", { i(1, "Heading"), i(0) })),

  -- Figure with image
  s(
    "fig",
    fmt(
      [[
#figure(
  image("{}", width: {}%),
  caption: [{}],
) {}]],
      { i(1, "path.png"), i(2, "80"), i(3, "Caption"), i(0) }
    )
  ),

  -- Table
  s(
    "tab",
    fmt(
      [[
#figure(
  table(
    columns: {},
    [{}], [{}],
    [{}], [{}],
  ),
  caption: [{}],
) {}]],
      { i(1, "2"), i(2, "Header 1"), i(3, "Header 2"), i(4), i(5), i(6, "Caption"), i(0) }
    )
  ),

  -- Equation (display)
  s("eq", fmt("$ {} $\n{}", { i(1), i(0) })),

  -- List
  s("lst", fmt("- {}\n- {}\n{}", { i(1), i(2), i(0) })),

  -- Numbered list
  s("enum", fmt("+ {}\n+ {}\n{}", { i(1), i(2), i(0) })),

  -- Link
  s("link", fmt('#link("{}")[{}]{}', { i(1, "url"), i(2, "text"), i(0) })),

  -- Label
  s("lbl", fmt("<{}>", { i(1, "label") })),

  -- Reference
  s("ref", fmt("@{}", { i(1, "label") })),

  -- Set rule
  s("set", fmt("#set {}({})\n{}", { i(1, "element"), i(2), i(0) })),

  -- Show rule
  s("show", fmt("#show {}: {}\n{}", { i(1, "selector"), i(2, "rule"), i(0) })),

  -- Import
  s("imp", fmt('#import "{}": {}\n{}', { i(1, "module"), i(2, "*"), i(0) })),

  -- Code block
  s(
    "code",
    fmt(
      [[
```{}
{}
```
{}]],
      { i(1, "lang"), i(2), i(0) }
    )
  ),

  -- Grid
  s(
    "grid",
    fmt(
      [[
#grid(
  columns: ({}),
  gutter: {},
  [{}],
  [{}],
) {}]],
      { i(1, "1fr, 1fr"), i(2, "1em"), i(3), i(4), i(0) }
    )
  ),

  -- Block with styling
  s(
    "block",
    fmt(
      [[
#block(
  fill: {},
  inset: {},
  radius: {},
  [{}],
) {}]],
      { i(1, "luma(230)"), i(2, "8pt"), i(3, "4pt"), i(4), i(0) }
    )
  ),

  -- Align
  s(
    "align",
    fmt(
      [[
#align({})[
  {}
] {}]],
      { i(1, "center"), i(2), i(0) }
    )
  ),

  -- Page setup
  s(
    "page",
    fmt(
      [[
#set page(paper: "{}", margin: ({}))
{}]],
      { i(1, "a4"), i(2, "x: 2cm, y: 2cm"), i(0) }
    )
  ),

  -- Text styling
  s("txt", fmt('#text(size: {}, weight: "{}")[{}]{}', { i(1, "12pt"), i(2, "regular"), i(3), i(0) })),

  -- Bibliography
  s("bib", fmt('#bibliography("{}")\n{}', { i(1, "refs.bib"), i(0) })),

  -- Outline (table of contents)
  s("toc", t("#outline()")),

  -- Pagebreak
  s("pb", t("#pagebreak()")),

  -- Highlight
  s("hl", fmt("#highlight[{}]{}", { i(1), i(0) })),

  -- Paragraph settings
  s("par", fmt("#set par(justify: {}, leading: {})\n{}", { i(1, "true"), i(2, "0.65em"), i(0) })),
}
