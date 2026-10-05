// Every ```typ example in the README must compile against the current source
// and import the current version (Typst Universe requires both).
#import "/src/lib.typ"

#let version = toml("/typst.toml").package.version
#let import-line = "#import \"@preview/gurps-ink:" + version + "\": *"
#let blocks = (
  read("/README.md")
    .replace("\r\n", "\n")
    .matches(regex("(?s)```typ\n(.*?)```"))
    .map(m => m.captures.first())
)

#assert(blocks.len() >= 2, message: "expected README examples")
#assert(
  blocks.first().starts-with(import-line),
  message: "first README example must start with " + import-line,
)
#for code in blocks {
  // eval cannot resolve @preview imports of an unpublished version, so the
  // import is replaced by handing the library in as the scope.
  let body = code.replace(import-line, "")
  assert(not body.contains("@preview/gurps-ink"), message: "stale import in README:\n" + code)
  let _ = eval(body, mode: "markup", scope: dictionary(lib))
}

// Other documentation must not mention an old version either.
#for path in ("/docs/manual.typ",) {
  for m in read(path).matches(regex("@preview/gurps-ink:([0-9.]+)")) {
    assert.eq(m.captures.first(), version, message: path + " has a stale import")
  }
}
