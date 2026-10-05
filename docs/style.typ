// Shared by docs/manual.typ and docs/how-to.typ.
#import "@preview/tidy:0.4.3"

#let version = toml("/typst.toml").package.version
#let import-line = "#import \"@preview/gurps-ink:" + version + "\": *"

// Every example shows its code on the left and its result on the right.
// The result is shown at its real size, in the body font.
#let preview-block(body, ..args) = block(..args, {
  set text(font: "Libertinus Serif", size: 10pt)
  body
})
// An example never breaks across pages.
#let layout-example(..args) = block(
  breakable: false,
  tidy.show-example.default-layout-example(
    ..args,
    code-block: block.with(radius: 3pt, stroke: .5pt + luma(200)),
    preview-block: preview-block.with(radius: 3pt, stroke: .5pt + luma(200)),
    dir: ltr,
    scale-preview: 100%,
  ),
)
