// Every public definition (re-exported from src/lib.typ) has a tidy
// doc-comment directly above it, ending in its return type (`/// -> type`).
#let lib = read("/src/lib.typ")

// (file, name) for every name imported into lib.typ.
#let exports = (
  lib
    .matches(regex("(?s)#import \"([^\"]+)\": \\(?([^)#]*)\\)?"))
    .map(m => {
      let (file, names) = m.captures
      names.split(",").map(str.trim).filter(n => n != "").map(n => (file, n))
    })
    .join()
)

// The parser finds exactly the names the module exports, no more, no less.
#import "/src/lib.typ" as gurps-ink
#assert.eq(
  exports.map(((file, name)) => name).sorted(),
  dictionary(gurps-ink).keys().sorted(),
)

// The parser sees both import styles in lib.typ: lists and single names.
#assert(("text.typ", "sjgames-game-aid") in exports)
#assert(("stat-block.typ", "stat-block") in exports)
#assert(("damage.typ", "swing") in exports)

#for (file, name) in exports {
  let lines = read("/src/" + file).split("\n")
  let at = lines.position(l => (
    l.starts-with("#let " + name + "(") or l.starts-with("#let " + name + " =")
  ))
  assert(
    at != none,
    message: name + " is exported but not defined in src/" + file,
  )
  // The doc-comment is the run of `///` lines straight above the definition.
  let doc = lines.slice(0, at).rev().position(l => not l.starts-with("///"))
  let doc-lines = lines.slice(at - doc, at)
  assert(
    doc-lines.len() > 0,
    message: name + " in src/" + file + " has no /// doc-comment",
  )
  assert(
    doc-lines.last().match(regex("^/// ->\\s*\\S")) != none,
    message: name
      + " in src/"
      + file
      + " must end its doc-comment with `/// -> type`",
  )
}
