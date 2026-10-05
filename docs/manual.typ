// The gurps-ink manual. Build with `just doc` (writes docs/manual.pdf).
//
// It is a user guide first and a reference second. The user guide has
// one chapter for each thing that the package does (legal notices, dice
// and books, characters). Each chapter starts with the questions that it
// answers, and each section answers one question. One example, the
// Tortoise and the Hare, runs through the whole manual.
//
// Write in ASD-STE100 style: short sentences, active voice, instructions
// in the imperative, one word for one thing. Do not explain GURPS rules:
// the reader knows GURPS.

#import "@preview/tidy:0.4.3"
#import "/src/lib.typ"
#import "/src/lib.typ": *
#import "style.typ": import-line, layout-example, version

#set document(title: "gurps-ink manual", author: "Nathanael Farley")
#set page(numbering: "1", margin: (x: 2cm, y: 2.5cm))
// Number chapters, sections and subsections only. The reference has
// deeper headings for parameters; numbers would not help there.
#set heading(numbering: (..n) => if n.pos().len() <= 3 {
  numbering("1.1", ..n)
})
#show link: set text(fill: blue.darken(30%))

#align(center)[
  #text(2em, weight: "bold")[gurps-ink] \
  Typeset unofficial #gurps material \
  User guide and reference, version #version
]

#outline(depth: 2)

#show heading.where(level: 1): it => pagebreak(weak: true) + it

= What gurps-ink does <overview>

`gurps-ink` is a Typst package for people who write unofficial #gurps
material: a sourcebook, an adventure or a handout. It does three things.

#table(
  columns: (auto, 1fr, auto),
  stroke: none,
  inset: (x: 4pt, y: 6pt),
  table.hline(),
  [*Task*], [*What gurps-ink gives you*], [*Chapter*],
  table.hline(stroke: 0.5pt),
  [Legal notices],
  [The disclaimer and the notice that the #sjgames online
    policy asks for, and #gurps in bold italics.],
  [@legal],
  [Dice and books],
  [Dice such as #dice(2, -1), damage from ST, and references such as
    #gurps-book("Magic", 14).],
  [@dice],

  [Characters], [Stat blocks that calculate their point costs.],
  [@characters],
  table.hline(),
)

It does not do these things:

- It does not copy the look of #gurps books. The #sjgames online policy
  does not let you do that (@legal-look). `gurps-ink` follows the
  typographic rules of #sjgames, and you choose the fonts and layout.
- It does not give legal advice.
- It does not calculate the cost of advantages and disadvantages. You
  give these costs.
- It does not import characters from GURPS Character Sheet (GCS).

== How to use this manual

Start with @start. Then go to the chapter for your task. Each chapter
starts with a list of the questions that it answers. Each section
answers one question.

In each example, the code is on the left and the result is on the right.
Each example in chapters 2 to 5 is complete: copy it into a new file and
it compiles. A reference example (@reference) needs the import line
first.

The examples use one story: a race between the Tortoise and the Hare.
@example shows the complete one-shot adventure that they come from.

== Find your question <questions>

#table(
  columns: (1fr, auto),
  stroke: none,
  inset: (x: 4pt, y: 5pt),
  table.hline(),
  [*I want to …*], [*Go to*],
  table.hline(stroke: 0.5pt),
  [install `gurps-ink`], [@start],
  [add the notices that #sjgames asks for], [@legal-notices],
  [know if my book can look like a #gurps book], [@legal-look],
  [write dice or damage], [@dice-dice, @dice-damage],
  [refer to a #gurps book or page], [@dice-books],
  [make a stat block], [@characters-make],
  [know which costs I must give], [@characters-costs],
  [hide point costs in a handout], [@characters-hide],
  [write a character's numbers in my text], [@characters-quote],
  [use one character in many chapters], [@characters-file],
  [keep a character in a point budget], [@characters-budget],
  [keep a stat block in one column], [@characters-column],
  [change the look of a stat block], [@characters-look],
  [make a cast list], [@characters-layout],
  [understand an error], [@characters-errors],
  [see a complete adventure], [@example],
  [look up a function], [@reference],
  table.hline(),
)

= Get started <start>
#include "chapters/start.typ"

= Legal notices and trademarks <legal>
#include "chapters/legal.typ"

= Dice and book references <dice>
#include "chapters/dice.typ"

= Characters and stat blocks <characters>
#include "chapters/characters.typ"

= Example: The Tortoise and the Hare <example>

This one-shot adventure uses each part of `gurps-ink`. Its source is
#link("https://github.com/natfarleydev/gurps-typst/blob/main/docs/example/tortoise-and-hare.typ")[`docs/example/tortoise-and-hare.typ`].
The PDF is
#link("https://github.com/natfarleydev/gurps-typst/blob/main/docs/tortoise-and-hare.pdf")[`docs/tortoise-and-hare.pdf`].

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  ..range(1, 3).map(p => block(
    stroke: 0.5pt + luma(200),
    image("tortoise-and-hare-" + str(p) + ".png", width: 100%),
  ))
)

#table(
  columns: (1fr, auto),
  stroke: none,
  inset: (x: 4pt, y: 5pt),
  table.hline(),
  [*In the adventure*], [*How it is made*],
  table.hline(stroke: 0.5pt),
  [Fonts, colours and page size of its own], [@legal-look],
  [#gurps and #gurps-book("Basic Set") in the introduction],
  [@legal-trademarks, @dice-books],

  [Two stat blocks that do not break],
  [@characters-make,
    @characters-column],
  [The Tortoise is built on 50 points], [@characters-budget],
  [Skill levels in the text of the race], [@characters-quote],
  [#dice(3) for the nap roll], [@dice-dice],
  [The disclaimer and the notice at the end], [@legal-notices],
  table.hline(),
)

The source follows.

#{
  // The source from its import line on, with the import that a reader
  // writes.
  let local-import = "#import \"/src/lib.typ\": *"
  let source = read("example/tortoise-and-hare.typ").replace("\r\n", "\n")
  set text(size: 0.75em)
  raw(
    import-line + source.split(local-import).last(),
    lang: "typst",
    block: true,
  )
}

= Reference <reference>

This chapter lists each function, in the same groups as chapters 3 to 5.
Each example needs the import line first.

#let modules = (
  "/src/text.typ",
  "/src/damage.typ",
  "/src/character.typ",
  "/src/stat-block.typ",
).map(path => tidy.parse-module(read(path), scope: dictionary(lib)))
#let style = (
  dictionary(tidy.styles.default)
    + (
      show-example: (..args) => tidy.show-example.show-example(
        ..args,
        layout: layout-example,
      ),
    )
)
// Shows the documented definitions with these names, in this order.
#let show-group(..names) = {
  let functions = modules.map(m => m.functions).join()
  let variables = modules.map(m => m.variables).join()
  let pick(docs) = names
    .pos()
    .map(n => docs.find(d => d.name == n))
    .filter(d => d != none)
  tidy.show-module(
    modules.first() + (functions: pick(functions), variables: pick(variables)),
    show-module-name: false,
    show-outline: false,
    sort-functions: none,
    style: style,
  )
}

== Legal notices and trademarks <reference-legal>
#show-group(
  "sjgames-disclaimer",
  "sjgames-notice",
  "gurps",
  "sjgames",
  "sjgames-game-aid",
)

== Dice and book references <reference-dice>
#show-group("dice", "thrust", "swing", "gurps-book", "basic-set")

== Characters and stat blocks <reference-characters>
#show-group(
  "character",
  "stat-block",
  "advantage",
  "disadvantage",
  "perk",
  "quirk",
  "skill",
  "spell",
  "melee-attack",
  "ranged-attack",
  "level-of",
  "total-points",
)

= Legal

#sjgames-disclaimer

#sjgames-notice
