// The gurps-ink manual. Build with `just doc` (writes docs/manual.pdf).
//
// Structure (Diátaxis): a tutorial, how-to guides, an explanation and a
// reference. The reference is generated from the doc-comments in src/.
// Write in ASD-STE100 style: short sentences, active voice, instructions
// in the imperative, one word for one thing.

#import "@preview/tidy:0.4.3"
#import "/src/lib.typ"
#import "/src/lib.typ": *
#import "style.typ": import-line, layout-example, version


#set document(title: "gurps-ink manual", author: "Nathanael Farley")
#set page(numbering: "1", margin: (x: 2cm, y: 2.5cm))
#set heading(numbering: "1.1")
#show link: set text(fill: blue.darken(30%))


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

#include "how-to.typ"

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
