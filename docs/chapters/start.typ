#import "/src/lib.typ": *
#import "../style.typ": answers, examples
#show: examples

#answers(
  [How do I install `gurps-ink`?],
  [What does a first page look like?],
)

== Install gurps-ink

`gurps-ink` is not on Typst Universe yet. Until it is, install it on
your computer:

+ Install #link("https://github.com/typst/typst#installation")[Typst]
  and #link("https://just.systems")[just].
+ Clone the #link("https://github.com/natfarleydev/gurps-typst")[repository].
+ In the repository, run `just install`.
+ In your document, write `#import "@local/gurps-ink:0.1.0": *`.

When `gurps-ink` is on Typst Universe, you do not install it. Write
`#import "@preview/gurps-ink:0.1.0": *` and Typst downloads it. This also
works in the #link("https://typst.app")[Typst web app]. The examples in
this manual use this import.

== Make your first page

Copy this example into a new file and compile it. It makes a character,
shows its stat block and adds the disclaimer.

```typ
#import "@preview/gurps-ink:0.1.0": *

#let tortoise = character(
  name: "The Tortoise",
  ht: 13,
  basic-move: 1,
  skill("Hiking", 14, "HT/A"),
)

#stat-block(tortoise)

The Tortoise walks at Move
#level-of(tortoise, "Basic Move").

#text(size: 7pt, sjgames-disclaimer)
```

The import line gives you all functions of `gurps-ink`. The next three
chapters show what you can do with them.
