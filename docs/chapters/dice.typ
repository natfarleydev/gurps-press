#import "/src/lib.typ": *
#import "../style.typ": answers, examples
#show: examples

#let style-guide = "https://www.sjgames.com/general/guidelines/authors/style.html"

#answers(
  [How do I write dice, such as 3d or 2d−1? (@dice-dice)],
  [How do I write the damage for a ST? (@dice-damage)],
  [How do I refer to a #gurps book or a page of it? (@dice-books)],
  [Where do these rules come from? (@dice-sources)],
)

== Write dice <dice-dice>

Use `dice(count, modifier)`. The modifier is optional. A negative
modifier has a true minus sign, not a hyphen. The result does not break
across lines.

```typ
#import "@preview/gurps-press:0.1.0": *

The Hare rolls #dice(3) against
its self-control number.
Its kick does #dice(1, -4) cr.
With a symbol: #dice(2, $n$).
```

== Write damage from ST <dice-damage>

`thrust(st)` and `swing(st)` give the basic damage for a ST, from the
table on #basic-set(16). They cover ST 1 to 100. Spread the result into `dice`
with `..`.

```typ
#import "@preview/gurps-press:0.1.0": *

At ST 6, the Hare kicks for
#dice(..thrust(6)) cr.
At ST 13, a sword swings for
#dice(..swing(13)) cut.
```

A character from `character()` has its damage in `thr` and `sw`
(@characters-quote).

== Refer to a GURPS book <dice-books>

Use `gurps-book(title, pages)`. Do not write "GURPS" in the title: the
function adds it. The pages are optional. If you give them, a comma
follows the title. One page gets "p."; more pages get "pp.".

```typ
#import "@preview/gurps-press:0.1.0": *

You need the #gurps-book("Basic Set").
See #gurps-book("Magic", 14) and
#gurps-book("Fantasy", (12, 20)).
```

For a page of the _Basic Set_, use `basic-set(pages)`. It writes
"p. B348", with no title. `gurps-book("Basic Set", 348)` stops with an
error that tells you to use `basic-set`.

```typ
#import "@preview/gurps-press:0.1.0": *

Roll a Quick Contest (#basic-set(348)).
See #basic-set((16, 170)).
```

To show the title of the _Basic Set_ with a page, write the title as
content: `gurps-book([Basic Set], 348)`.

== Where the rules come from <dice-sources>

The dice notation, the bold italic book titles and the page references
follow the
#link(style-guide)[#sjgames Authors' Guidelines: Editorial Style]. The
damage table is on #basic-set(16).
