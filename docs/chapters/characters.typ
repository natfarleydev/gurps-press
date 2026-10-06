#import "/src/lib.typ": *
#import "../style.typ": answers, examples
#show: examples

#answers(
  [How do I make a character and show its stat block?
    (@characters-make)],
  [Which point costs does `gurps-press` calculate? (@characters-costs)],
  [How do I hide the point costs? (@characters-hide)],
  [How do I write a character's numbers in my text?
    (@characters-quote)],
  [How do I use one character in many chapters? (@characters-file)],
  [How do I keep a character in a point budget? (@characters-budget)],
  [How do I stop a column break from splitting a stat block?
    (@characters-column)],
  [How do I change the look of a stat block? (@characters-look)],
  [How do I make a cast list or another layout? (@characters-layout)],
  [What does an error message mean? (@characters-errors)],
)

A character has two steps. `character()` makes a dictionary and
calculates the costs. `stat-block()` shows the dictionary. Because the
two steps are separate, you can make a character once and use it in
many places.

== Make a character and show it <characters-make>

Give the attributes as named arguments. Give only the attributes that
are not the default. Give the traits, skills, spells and attacks as
positional arguments, in any order.

```typ
#import "@local/gurps-press:0.1.0": *

#let hare = character(
  name: "The Hare",
  st: 6, dx: 13, ht: 11,
  sm: -2,
  basic-move: 9,
  disadvantage(
    "Overconfidence (12)",
    points: -5,
  ),
  quirk("Naps after lunch"),
  skill("Running", 16, "HT/A"),
  melee-attack("Kick", 13,
    [#dice(1, -4) cr], reach: "C"),
)
#stat-block(hare)
```

The functions for traits are `advantage`, `disadvantage`, `perk` and
`quirk`. For skills and spells, they are `skill` and `spell`. For
attacks, they are `melee-attack` and `ranged-attack`. The reference
(@reference-characters) shows all their arguments.

== Know which costs are calculated <characters-costs>

#table(
  columns: 2,
  [*`character()` calculates*], [*You give*],
  [The cost of each attribute and secondary characteristic],
  [The cost of each advantage and disadvantage, with `points:`],

  [The cost of a skill or spell, if you give its base and difficulty,
    such as `"HT/A"`],
  [The cost of a skill or spell, if you give a number instead],

  [Dodge, from Basic Speed], [The skill level and damage of each attack],
  [Thrust and swing damage, from ST 1 to 100],
  [Damage above ST 100, with `thr:` and `sw:`],

  [The point total], [Discounts, such as the SM discount to ST],
)

A value that you give always replaces the calculated value. To give
the cost of an attribute, give a dictionary: `st: (level: 20,
points: 90)`. If an advantage or disadvantage has no `points:`, the
stat block shows `[?]` and the total counts it as 0.

```typ
#import "@local/gurps-press:0.1.0": *

#stat-block(character(
  name: "The Tortoise",
  ht: 13,
  advantage("Fit", points: 5),
  advantage("Patience"),
  skill("Hiking", 14, "HT/A"),
  skill("Fast-Talk", 12, 4),
))
```

A skill can also have another skill of the same character as its base,
such as `"Running/E"`.

== Hide point costs <characters-hide>

Players do not need point costs in a handout or a bestiary. Use
`show-points: false`.

```typ
#import "@local/gurps-press:0.1.0": *

#stat-block(
  character(
    name: "The Hare",
    dx: 13,
    skill("Running", 16, "HT/A"),
  ),
  show-points: false,
)
```

== Write a character's numbers in your text <characters-quote>

Use `level-of(char, name)` for the level of an attribute, skill or
spell. Use `char.thr` and `char.sw` for the damage. If you change the
character, the text changes too.

```typ
#import "@local/gurps-press:0.1.0": *

#let hare = character(
  st: 6, dx: 13,
  basic-move: 9,
  skill("Running", 16, "HT/A"),
)

The Hare has Move
#level-of(hare, "Basic Move") and
Running-#level-of(hare, "Running").
It kicks for #dice(..hare.thr) cr.
```

== Use one character in many chapters <characters-file>

Put all characters in one dictionary. Then each chapter can use the
same characters.

```typ
#import "@local/gurps-press:0.1.0": *

#let npcs = (
  tortoise: character(
    name: "The Tortoise", ht: 13),
  hare: character(
    name: "The Hare", dx: 13),
)

The Tortoise has
#level-of(npcs.tortoise, "HT") HT.
The Hare has
#level-of(npcs.hare, "DX") DX.
```

Put the import line and the `#let npcs = (..)` lines in a file, for
example `npcs.typ`. In each chapter, write `#import "npcs.typ": npcs`.

== Keep a character in a point budget <characters-budget>

Use `assert` with `total-points`. If the character costs too much,
compilation stops and shows your message. This is useful for a
pregenerated character or a template.

```typ
#import "@local/gurps-press:0.1.0": *

#let tortoise = character(
  name: "The Tortoise",
  iq: 11, ht: 13,
  basic-move: 1,
)
#assert(
  total-points(tortoise) <= 50,
  message: "Over 50 points",
)
#stat-block(tortoise)
```

== Keep a stat block in one column <characters-column>

A stat block can break across columns and pages. To prevent this, put
it in a block that cannot break.

```typ
#import "@local/gurps-press:0.1.0": *

#block(
  breakable: false,
  stat-block(character(
    name: "The Hare")),
)
```

== Change the look of a stat block <characters-look>

Use the hooks of `stat-block()`. The `title` hook makes the first line.
The `section` hook makes each list, such as "Skills". To frame a stat
block, put it in a `block` with a `stroke`.

```typ
#import "@local/gurps-press:0.1.0": *

#block(stroke: 0.5pt, inset: 6pt,
  stat-block(
    character(
      name: "The Hare",
      skill("Running", 16, "HT/A"),
    ),
    title: (char, total) => smallcaps(
      [#char.name, #total points],
    ),
    section: (label, body) => [
      #emph(label) --- #body
    ],
  ))
```

== Make a cast list or another layout <characters-layout>

Write a function that takes the dictionary from `character()`. The
reference for `character()` (@reference-characters) shows all keys of
this dictionary.

```typ
#import "@local/gurps-press:0.1.0": *

#let cast(char) = {
  let skills = char.skills
    .map(s => [#s.name\-#s.level])
  [*#char.name* (#total-points(char)
    points): #skills.join[, ].]
}

#cast(character(
  name: "The Tortoise", ht: 13,
  skill("Hiking", 14, "HT/A"),
))

#cast(character(
  name: "The Hare", dx: 13,
  skill("Running", 16, "HT/A"),
))
```

When Typst gets user-defined elements, `stat-block` will become one.
Then show and set rules can change it, as they change built-in elements.

== Understand an error <characters-errors>

When an input is wrong, compilation stops. The message tells you what is
wrong. This table shows the frequent messages.

#table(
  columns: 2,
  [*The message contains*], [*Do this*],
  [`is too low to buy`],
  [Make the skill level higher, or give the points as a number.],

  [`cannot work out the cost of`],
  [Make sure that the base (`"HT"` in `"HT/A"`) is the name of an
    attribute, skill or spell of the same character.],

  [`more than one skill or spell is called`],
  [Give each skill and spell a different name.],

  [`got unknown argument(s)`],
  [Make sure that you spell the argument correctly.],

  [`covers ST 1 to 100`], [Give `thr:` and `sw:` to `character()`.],
  [`points must be zero or negative`],
  [Give a disadvantage a negative cost, for example `points: -10`.],
)
