// The gurps-ink manual. Build with `just doc` (writes docs/manual.pdf).
// The reference section is generated from the doc-comments in src/.

#import "@preview/tidy:0.4.3"
#import "/src/lib.typ"
#import "/src/lib.typ": *

#let version = toml("/typst.toml").package.version

#set document(title: "gurps-ink manual", author: "Nathanael Farley")
#set page(numbering: "1", margin: (x: 2.5cm, y: 2.5cm))
#set heading(numbering: "1.1")
#show link: set text(fill: blue.darken(30%))
#show raw.where(block: true): block.with(
  fill: luma(245), inset: 8pt, radius: 3pt, width: 100%,
)

#align(center)[
  #text(2em, weight: "bold")[gurps-ink] \
  Typeset #gurps game aids \
  Version #version
]

#outline(depth: 1)

= Introduction

`gurps-ink` helps you write home-made #gurps material: adventures, NPC
handouts, house-rule documents. It gives you

- dice in #gurps notation (#dice(3, -1)) and book references
  (#gurps-book("Basic Set", 16));
- the boilerplate the Steve Jackson Games online policy asks for;
- NPC stat blocks that work out point costs, secondary characteristics and
  basic damage for you.

It is a port of the LaTeX package
#link("https://github.com/natfarleydev/gurps-latex-package")[`gurps`].

= Quick start

```typ
#import "@preview/gurps-ink:0.1.0": *

#let napoleon = character(
  name: "Napoleon",
  st: 9, hp: 12,
  advantage("Natural afro", points: 1),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  melee-attack("Punch", 18, [#dice(1, -2) cr], reach: "C"),
)

#stat-block(napoleon)

#sjgames-disclaimer
```

#block(stroke: 0.5pt + luma(180), inset: 8pt, radius: 3pt, stat-block(character(
  name: "Napoleon",
  st: 9, hp: 12,
  advantage("Natural afro", points: 1),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  melee-attack("Punch", 18, [#dice(1, -2) cr], reach: "C"),
)))

= Building characters

A character is built in two steps. `character()` collects everything and
works out the numbers; it returns a plain dictionary. `stat-block()` turns
that dictionary into content. Keeping them apart means you can define a
character once and print it, or quote its numbers, anywhere:

```typ
#import "@preview/gurps-ink:0.1.0": *

#let guard = character(st: 12, skill("Broadsword", 13, "DX/A"))
The guard swings for #dice(..guard.sw) and has
#level-of(guard, "HP") HP.
```

Only say what differs from an average human. Leave a cost out and it is
calculated; give one and it is used as-is. Traits whose cost cannot be
calculated (advantages without points) show `[?]` and count as 0.

== Coming from the LaTeX package

#table(
  columns: 2,
  [*LaTeX*], [*Typst*],
  [`\gurps`], [`#gurps`],
  [`\dice{3}[-1]`], [`#dice(3, -1)`],
  [`\gurpsbook{Zombies}[3]`], [`#gurps-book("Zombies", 3)`],
  [`\SJGamesOnlinePolicyDisclaimer`], [`#sjgames-disclaimer`],
  [`\SJGamesOnlinePolicyNotice`], [`#sjgames-notice`],
  [`\SJGamesOnlinePolicyGameAid{Me}`], [`#sjgames-game-aid[Me]`],
  [`\begin{character} … \end{character}`], [`#stat-block(character(…))`],
  [`\begin{character*}[key]`], [`#let key = character(…)`],
  [`\GCPrintCharacter[key]`], [`#stat-block(key)`],
  [`\ST{13}[25]`], [`st: (level: 13, points: 25)`],
  [`\skill{Stealth}[DX/Average]{12}`], [`skill("Stealth", 12, "DX/A")`],
  [`\levelledadvantage{Magery}{2}[25]`], [`advantage("Magery", points: 25, level: 2)`],
  [`\meleeattack{name=…, level=…}`], [`melee-attack(name, level, damage, reach: …)`],
  [`\GCGet{ST}\GCResult`], [`#level-of(key, "ST")`],
  [`\GCTotalPoints`], [`#total-points(key)`],
  [`\GCAddToLevel{HP}{4}`], [pass the final value, e.g. `hp: 16`],
)

Reading characters from GCS files is not supported yet.

= Writing your own renderer

`stat-block()` covers the layout of the SJ Games books, and its `title`
and `section` hooks restyle parts of it. For anything else (a table, a
one-line summary for an adventure's cast list, a card) build your own from
the dictionary `character()` returns. Its shape is public API, documented
under `character` in the reference below.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let one-liner(char) = {
  let attributes = ("ST", "DX", "IQ", "HT").map(k => [#k #char.attributes.at(k).level])
  let skills = char.skills.map(s => [#s.name\-#s.level])
  [*#char.name:* #attributes.join[, ]. _Skills:_ #skills.join[, ].]
}

#one-liner(character(name: "Guard", st: 11, skill("Spear", 12, "DX/A")))
```

#let one-liner(char) = {
  let attributes = ("ST", "DX", "IQ", "HT").map(k => [#k #char.attributes.at(k).level])
  let skills = char.skills.map(s => [#s.name\-#s.level])
  [*#char.name:* #attributes.join[, ]. _Skills:_ #skills.join[, ].]
}
#block(stroke: 0.5pt + luma(180), inset: 8pt, radius: 3pt,
  one-liner(character(name: "Guard", st: 11, skill("Spear", 12, "DX/A"))))

Point costs are already worked out (`char.skills.first().points`), and
`total-points(char)` gives the total.

Once Typst supports user-defined elements, `stat-block` will become one,
so that show and set rules can restyle it like a built-in. Until then the
hooks and your own functions are the way to customise it.

= Reference

// Examples stack code above output at full width, so paragraphs and stat
// blocks are shown at their real size, in the body font, instead of shrunk
// into a column in the code font.
#let preview-block(body, ..args) = block(..args, {
  set text(font: "Libertinus Serif", size: 11pt)
  body
})
#let style = dictionary(tidy.styles.default) + (
  show-example: (..args) => tidy.show-example.show-example(
    ..args,
    layout: tidy.show-example.default-layout-example.with(
      code-block: block.with(radius: 3pt, stroke: .5pt + luma(200)),
      preview-block: preview-block.with(radius: 3pt, stroke: .5pt + luma(200)),
      dir: ttb,
      scale-preview: 100%,
    ),
  ),
)

#let show-file(path) = {
  let docs = tidy.parse-module(
    read(path),
    scope: dictionary(lib),
  )
  tidy.show-module(docs, show-outline: false, sort-functions: none, style: style)
}

== Text and dice
#show-file("/src/text.typ")

== Damage
#show-file("/src/damage.typ")

== Characters
#show-file("/src/character.typ")

== Stat blocks
#show-file("/src/stat-block.typ")

= Legal

#sjgames-disclaimer

#sjgames-notice
