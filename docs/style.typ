// Shared by docs/manual.typ and the chapter files in docs/chapters/.
#import "@preview/tidy:0.4.3"
#import "/src/lib.typ"

#let (name, version) = toml("/typst.toml").package
#let import-line = "#import \"@preview/" + name + ":" + version + "\": *"

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

// Apply with `#show: examples` at the top of a chapter file. Then each
// ```typ block in that file is compiled and shown next to its result.
// tests/readme checks that each block imports the current version.
#let examples(body) = {
  show raw.where(block: true, lang: "typ"): it => layout-example(
    it,
    eval(
      it.text.replace(import-line, ""),
      mode: "markup",
      scope: dictionary(lib),
    ),
  )
  body
}

// The box at the start of each chapter: the questions that it answers.
#let answers(..questions) = block(
  fill: luma(245),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
  [*This chapter answers:* #list(..questions.pos())],
)
