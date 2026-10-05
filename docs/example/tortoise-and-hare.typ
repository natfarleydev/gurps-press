// An example sourcebook: a one-shot adventure made with gurps-ink.
// `just doc` compiles it to docs/tortoise-and-hare.pdf, and the manual
// shows its pages. In your own document, import the package with
// #import "@preview/gurps-ink:0.1.0": *
#import "/src/lib.typ": *

// Your own look: gurps-ink sets no fonts, colours or page layout.
#set document(title: "The Tortoise and the Hare")
#set page(paper: "a5", margin: (x: 15mm, y: 18mm), numbering: "1")
#set text(size: 9.5pt)
#set par(justify: true)
#show heading: set text(fill: rgb("#2f5d50"))
#show heading.where(level: 1): set text(size: 16pt)

// The two characters. Each section below uses them again.
#let tortoise = character(
  name: "The Tortoise",
  iq: 11,
  ht: 13,
  basic-move: 1,
  dr: [3 (shell)],
  advantage("Damage Resistance (Tough Shell)", points: 15, level: 3),
  advantage("Fit", points: 5),
  disadvantage("Stubbornness", points: -5),
  quirk("Never hurries"),
  skill("Running", 14, "HT/A"),
  skill("Fast-Talk", 11, "IQ/A"),
)
#let hare = character(
  name: "The Hare",
  st: 6,
  dx: 13,
  ht: 11,
  sm: -2,
  basic-move: 9,
  disadvantage("Overconfidence (12)", points: -5),
  quirk("Naps after lunch"),
  skill("Running", 13, "HT/A"),
  melee-attack("Kick", 13, [#dice(..thrust(6)) cr], reach: "C"),
)

// The player builds the Tortoise on 50 points. Compilation stops if a
// change makes it cost more.
#assert(total-points(tortoise) <= 50, message: "The Tortoise is over 50 points")

= The Tortoise and the Hare

A one-shot adventure for #gurps. One player is the Tortoise. The GM is
the Hare. It takes about 30 minutes. You need the
#gurps-book("Basic Set").

== The Challenge

The Hare boasts that no animal in the meadow can beat it in a race. The
Tortoise accepts the challenge. The race starts at the old oak and ends
at the mill pond, one mile away.

== The Characters

The player uses the Tortoise. It is built on 50 points.

#block(breakable: false, stat-block(tortoise))

The GM plays the Hare. The Hare is fast, but it has Overconfidence
(p. B148).

#block(breakable: false, stat-block(hare))

== The Race

The race has three steps.

+ *Taunt (optional).* Before the start, the Tortoise can mock the Hare.
  Roll a Quick Contest (p. B348) of the Tortoise's Fast-Talk-#level-of(tortoise, "Fast-Talk")
  against the Hare's Will of #level-of(hare, "Will"). If the Tortoise
  wins, the Hare takes −2 on its roll in step 2.
+ *The nap.* Halfway, the Hare is far ahead. The GM rolls #dice(3)
  against the Hare's self-control number of 12 (p. B120). On a failure,
  the Hare stops for a nap.
+ *The finish.* Roll a Quick Contest of Running (p. B218): the
  Tortoise's Running-#level-of(tortoise, "Running") against the Hare's
  Running-#level-of(hare, "Running"). The Hare gets +4 for its speed.
  If it took a nap, it gets −6 instead. The winner reaches the pond
  first. On a tie, the Tortoise wins by the length of its nose.

== After the Race

If the Tortoise wins, the meadow cheers. Give the player 1 character
point. If the Hare wins, it boasts for a week. The player still gets 1
character point: slow and steady learns a lesson too.

#v(1fr)
#line(length: 100%, stroke: 0.4pt)
#set text(size: 7pt)
#sjgames-disclaimer

#sjgames-notice
