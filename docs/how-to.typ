// The how-to guides of the manual, included by docs/manual.typ. They
// are in their own file so that the show rule below applies only here.
#import "/src/lib.typ"
#import "/src/lib.typ": *
#import "style.typ": import-line, layout-example

// In this part, each ```typ block is an example: it is shown next to
// its result. tests/readme checks that each one imports this version.
#show raw.where(block: true, lang: "typ"): it => layout-example(
  it,
  eval(
    it.text.replace(import-line, ""),
    mode: "markup",
    scope: dictionary(
      lib,
    ),
  ),
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

  [`got unknown argument(s)`],
  [Make sure that you spell the argument correctly.],

  [`covers ST 1 to 100`], [Give `thr:` and `sw:` to `character()`.],
  [`points must be zero or negative`],
  [Give a disadvantage a negative cost, for example `points: -10`.],
)
