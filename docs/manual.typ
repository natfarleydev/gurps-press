// The gurps-ink manual. Build with `just doc` (writes docs/manual.pdf).
//
// Structure (Diátaxis): a tutorial, how-to guides, an explanation and a
// reference. The reference is generated from the doc-comments in src/.
// Write in ASD-STE100 style: short sentences, active voice, instructions
// in the imperative, one word for one thing.

#import "@preview/tidy:0.4.3"
#import "/src/lib.typ"
#import "/src/lib.typ": *

#let version = toml("/typst.toml").package.version
#let import-line = "#import \"@preview/gurps-ink:" + version + "\": *"

#set document(title: "gurps-ink manual", author: "Nathanael Farley")
#set page(numbering: "1", margin: (x: 2cm, y: 2.5cm))
#set heading(numbering: "1.1")
#show link: set text(fill: blue.darken(30%))

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

#align(center)[
  #text(2em, weight: "bold")[gurps-ink] \
  Typeset unofficial #gurps material \
  Version #version
]

#outline(depth: 2)

= Introduction

Use `gurps-ink` to write an unofficial #gurps sourcebook, adventure or
handout in Typst. It typesets stat blocks and calculates their point
costs. It writes dice, damage and book references in the style of the
#sjgames books. It also gives you the notices that the #sjgames online
policy asks for.

This manual has four parts:

- *Tutorial* (@tutorial): make one sourcebook page, step by step. Start
  here if `gurps-ink` is new to you.
- *How-to guides* (@how-to): do one task, such as "hide point costs".
- *What gurps-ink calculates* (@calculates): know which numbers come
  from `gurps-ink` and which come from you.
- *Reference* (@reference): all functions and their arguments.

In each example, the code is on the left and the result is on the right.
Each example is complete: copy it into a new file and it compiles.

= Tutorial: make a sourcebook page <tutorial>

This tutorial makes the page on the right. It has a heading, text with a
book reference, two stat blocks and the legal notices.

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  block(radius: 3pt, stroke: .5pt + luma(200), inset: 5pt, width: 100%, {
    set text(size: 0.65em)
    raw(
      read("sourcebook.typ")
        .replace("\r\n", "\n")
        .split("\n")
        .filter(line => not line.starts-with("//"))
        .join("\n")
        .replace("#import \"/src/lib.typ\": *", import-line),
      lang: "typst",
      block: true,
    )
  }),
  block(
    radius: 3pt,
    stroke: .5pt + luma(200),
    inset: 5pt,
    image("sourcebook.png", width: 100%),
  ),
)

Do these steps:

+ Import `gurps-ink` on the first line. All its functions are then
  available.
+ Set up the page. This page has two columns, as many sourcebooks have.
+ Make the characters with `character()`. Put them in one dictionary,
  `npcs`. Then you can use each character again in the text.
+ Write the text. `#gurps-book("Basic Set", 348)` refers to a page of
  the Basic Set. `#dice(..npcs.sergeant.sw)` writes the swing damage of
  the sergeant.
+ Typeset each character with `stat-block()`. Put each stat block in
  `block(breakable: false, ..)`. Then a column break cannot split a stat
  block.
+ Add the legal notices at the end. Make them small with `text(size: ..)`.

Next, read the how-to guides for the tasks that you need.

= How-to guides <how-to>

#[
// In this part, each ```typ block is an example: it is shown next to
// its result. tests/readme checks that each one imports this version.
#show raw.where(block: true, lang: "typ"): it => layout-example(
  it,
  eval(it.text.replace(import-line, ""), mode: "markup", scope: dictionary(
    lib,
  )),
)

== Add the legal notices

The #sjgames online policy tells you which notices your material must
have. Read the policy before you publish. `gurps-ink` gives you the
text of three notices. It does not give legal advice.

```typ
#import "@preview/gurps-ink:0.1.0": *

#set text(size: 7pt)
#sjgames-disclaimer

#sjgames-notice

#sjgames-game-aid[Jane Doe]
```

- `sjgames-disclaimer` says that the material is yours and not official.
- `sjgames-notice` is the trademark and copyright notice.
- `sjgames-game-aid` is the notice for a free game aid. Give it the
  name of the author.

Put the notices on the title page or on the last page.

== Write dice and damage

Use `dice(count, modifier)`. The result does not break across lines,
and a negative modifier has a true minus sign. To write basic damage,
spread `thrust(st)` or `swing(st)` into `dice`.

```typ
#import "@preview/gurps-ink:0.1.0": *

Roll #dice(3) against your skill.
The trap does #dice(2, -1) cr.
A ST 13 sword does
#dice(..swing(13)) cut.
A spell does #dice(1, $n$) burn.
```

== Refer to GURPS books

Use `gurps-book(title, pages)`. Do not write "GURPS" in the title: the
function adds it. If you refer to a book many times, make a short
function for it.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let basic(..pages) = gurps-book(
  "Basic Set", ..pages,
)

See #gurps-book("Magic", 14),
#basic(16) and
#basic((170, 344)).
```

== Make a stat block

Make the character with `character()`. Give the attributes as named
arguments. Give the traits, skills, spells and attacks as positional
arguments, in any order. Then typeset the character with `stat-block()`.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let rat = character(
  name: "Giant Rat",
  st: 6, dx: 12, ht: 12,
  sm: -1,
  advantage("Night Vision",
    points: 5, level: 5),
  skill("Brawling", 13, "DX/E"),
  melee-attack("Bite", 13,
    [#dice(1, -4) cut], reach: "C"),
)
#stat-block(rat)
```

Give the point cost of each advantage and disadvantage with `points:`.
If you do not, the stat block shows `[?]` and the total counts it as 0.

== Keep your characters in one file

Put all characters in one dictionary. Then each chapter can use the
same characters. When you change a character, each chapter shows the
change.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let npcs = (
  rat: character(name: "Giant Rat",
    st: 6),
  ogre: character(name: "Ogre",
    st: 20),
)

The ogre has
#level-of(npcs.ogre, "HP") HP.
The rat has
#level-of(npcs.rat, "HP") HP.
```

Put the import line and the `#let npcs = (..)` lines in a file, for
example `npcs.typ`. In each chapter, write
`#import "npcs.typ": npcs`.

== Quote a character in the text

Use `level-of(char, name)` to get the level of an attribute, skill or
spell. Use `char.thr` and `char.sw` to get the damage.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let ogre = character(
  st: 20,
  skill("Brawling", 12, "DX/E"),
)

The ogre has
#level-of(ogre, "HP") HP and
Brawling-#level-of(ogre, "Brawling").
It punches for #dice(..ogre.thr) cr.
```

== Hide point costs

Players do not need point costs in a handout or a bestiary. Use
`show-points: false`.

```typ
#import "@preview/gurps-ink:0.1.0": *

#stat-block(
  character(
    name: "Bandit",
    st: 11,
    skill("Shortsword", 12, "DX/A"),
  ),
  show-points: false,
)
```

== Check a point budget

For a pregenerated character or a template, use `assert` with
`total-points`. If the character costs too much, compilation stops with
your message.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let squire = character(
  name: "Squire",
  st: 11, dx: 12,
  skill("Broadsword", 13, "DX/A"),
)
#assert(
  total-points(squire) <= 100,
  message: "Squire is over budget",
)
#stat-block(squire)
```

== Keep a stat block in one column

A stat block can break across columns and pages. To prevent this, put
it in a block that cannot break.

```typ
#import "@preview/gurps-ink:0.1.0": *

#block(
  breakable: false,
  stat-block(character(name: "Guard")),
)
```

== Change how a stat block looks

Use the hooks of `stat-block()`. The `title` hook makes the first line.
The `section` hook makes each labelled list, such as "Skills".

```typ
#import "@preview/gurps-ink:0.1.0": *

#stat-block(
  character(
    name: "Guard",
    st: 11,
    skill("Spear", 12, "DX/A"),
  ),
  title: (char, total) => smallcaps(
    [#char.name, #total points],
  ),
  section: (label, body) => [
    #emph(label) --- #body
  ],
)
```

To frame a stat block, put it in a `block` with a `stroke`.

== Make your own layout

For a different layout, such as a cast list, write a function. Give it
the dictionary from `character()`. The reference for `character()`
(@reference) shows all keys of this dictionary.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let one-line(char) = {
  let attributes = ("ST", "DX", "IQ", "HT")
    .map(k => [#k #char.attributes.at(k).level])
  let skills = char.skills
    .map(s => [#s.name\-#s.level])
  [*#char.name:* #attributes.join[, ].
    _Skills:_ #skills.join[, ].]
}

#one-line(character(
  name: "Guard", st: 11,
  skill("Spear", 12, "DX/A"),
))
```

`char.skills.first().points` has the point cost of the first skill.
`total-points(char)` has the total.

When Typst gets user-defined elements, `stat-block` will become one.
Then show and set rules can change it, as they change built-in elements.

== Fix an error

When an input is wrong, compilation stops. The error message tells you
what is wrong. This table shows the frequent messages.

#table(
  columns: 2,
  [*The message contains*], [*Do this*],
  [`is too low to buy`],
  [Make the skill level higher, or give the points as a number.],

  [`cannot work out the cost of`],
  [Make sure that the base (`"DX"` in `"DX/A"`) is the name of an
    attribute, skill or spell of the same character.],

  [`more than one skill or spell is called`],
  [Give each skill and spell a different name.],

  [`got unknown argument(s)`], [Make sure that you spell the argument correctly.],
  [`covers ST 1 to 100`], [Give `thr:` and `sw:` to `character()`.],
  [`points must be zero or negative`],
  [Give a disadvantage a negative cost, for example `points: -10`.],
)
]

= What gurps-ink calculates <calculates>

`character()` calculates these values from the Basic Set rules:

- The point cost of each attribute and secondary characteristic.
- The point cost of each skill and spell that has a cost such as
  `"DX/A"`.
- Dodge, and thrust and swing damage from ST.
- The point total.

You must give these values:

- The point cost of each advantage and disadvantage.
- The skill level and damage of each attack.
- ST damage above ST 100. Give `thr:` and `sw:`.
- Discounts, such as the SM discount to ST. Give the cost yourself, for
  example `st: (level: 20, points: 90)`.

A value that you give always replaces the calculated value.

#pagebreak(weak: true)
= Reference <reference>

#let style = (
  dictionary(tidy.styles.default)
    + (
      show-example: (..args) => tidy.show-example.show-example(
        ..args,
        layout: layout-example,
      ),
    )
)

#let show-file(path) = {
  let docs = tidy.parse-module(
    read(path),
    scope: dictionary(lib),
  )
  tidy.show-module(
    docs,
    show-outline: false,
    sort-functions: none,
    style: style,
  )
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
