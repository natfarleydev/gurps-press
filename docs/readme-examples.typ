// The pictures of the README examples. `just doc` compiles this file
// to docs/readme-<n>.png: page n shows the n-th ```typ block of README.md.
// The pictures come from the README itself, so they cannot drift from it.
#import "/src/lib.typ"

#set page(width: 10cm, height: auto, margin: 5mm)
#set text(size: 9pt)

#let import-line = (
  "#import \"@preview/gurps-ink:"
    + toml("/typst.toml").package.version
    + "\": *"
)
#let blocks = (
  read("/README.md")
    .replace("\r\n", "\n")
    .matches(regex("(?s)```typ\n(.*?)```"))
    .map(m => m.captures.first())
)

#for (i, code) in blocks.enumerate() {
  if i > 0 { pagebreak() }
  eval(code.replace(import-line, ""), mode: "markup", scope: dictionary(lib))
}
