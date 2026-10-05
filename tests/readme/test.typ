// Every ```typ example in the README must compile against the current source
// and import the current version (Typst Universe requires both).
#import "/src/lib.typ"

#let (name, version) = toml("/typst.toml").package
#let import-line = "#import \"@preview/" + name + ":" + version + "\": *"
// The manual assumes a local install (`just install`); Universe needs the
// README to show the @preview import.
#let local-import-line = "#import \"@local/" + name + ":" + version + "\": *"
#let blocks = (
  read("/README.md")
    .replace("\r\n", "\n")
    .matches(regex("(?s)```typ\n(.*?)```"))
    .map(m => m.captures.first())
)

#assert(blocks.len() >= 1, message: "expected a README example")
// Every example is self-contained, so a reader can copy any one of them.
#for code in blocks {
  assert(
    code.starts-with(import-line),
    message: "README example must start with " + import-line + ":\n" + code,
  )
}
#for code in blocks {
  // eval cannot resolve @preview imports of an unpublished version, so the
  // import is replaced by handing the library in as the scope.
  let body = code.replace(import-line, "")
  assert(
    not body.contains("@preview/" + name),
    message: "stale import in README:\n" + code,
  )
  let _ = eval(body, mode: "markup", scope: dictionary(lib))
}

// The manual's examples are self-contained too, and import the local install.
#let manual-blocks = (
  (
    "/docs/chapters/start.typ",
    "/docs/chapters/legal.typ",
    "/docs/chapters/dice.typ",
    "/docs/chapters/characters.typ",
  )
    .map(read)
    .join()
    .replace("\r\n", "\n")
    .matches(regex("(?s)```typ\n(.*?)```"))
    .map(m => m.captures.first())
)
#assert(manual-blocks.len() >= 3, message: "expected manual examples")
#for code in manual-blocks {
  assert(
    code.starts-with(local-import-line),
    message: "manual example must start with "
      + local-import-line
      + ":\n"
      + code,
  )
}

// No documentation may mention an old name or version, in examples or prose.
#for path in (
  "/README.md",
  "/docs/manual.typ",
  "/docs/chapters/start.typ",
  "/docs/chapters/legal.typ",
  "/docs/chapters/dice.typ",
  "/docs/chapters/characters.typ",
  "/docs/example/tortoise-and-hare.typ",
) {
  for m in read(path).matches(
    regex("@(?:preview|local)/(gurps-[a-z-]+):([0-9.]+)"),
  ) {
    assert.eq(
      m.captures,
      (name, version),
      message: path + " has a stale import: " + m.text,
    )
  }
}
