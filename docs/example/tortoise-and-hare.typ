// An example sourcebook: a one-shot adventure made with gurps-ink.
// `just doc` compiles it to docs/tortoise-and-hare.pdf, and the manual
// shows its pages. In your own document, import the package with
// #import "@preview/gurps-ink:0.1.0": *
#import "/src/lib.typ": *

// Your own look: gurps-ink sets no fonts, colours or page layout.
#let accent = rgb("#2f5d50")
#set document(title: "The Tortoise and the Hare")
#set page(paper: "a5", margin: (x: 14mm, y: 15mm), numbering: "1")
#set text(size: 9pt)
#set par(justify: true)
#show heading: set text(fill: accent)
#show link: underline

// The old story, quoted beside the adventure. The text is the
// public-domain translation by George Fyler Townsend (1867).
#let aside(body, source: [Aesop]) = block(
  width: 100%,
  inset: (left: 8pt, y: 2pt),
  stroke: (left: 1.5pt + accent),
  text(fill: accent.darken(20%))[
    #set par(justify: false)
    #emph(body)
    #linebreak()
    --- #source
  ],
)

// The two characters. Each section below uses them again.
#let tortoise = character(
  name: "The Tortoise",
  st: 7,
  iq: 11,
  ht: 13,
  hp: 10,
  will: 13,
  basic-move: 1,
  sm: -3,
  dr: [3 (shell)],
  advantage("Damage Resistance (Tough Shell)", points: 15, level: 3),
  advantage("Very Fit", points: 15),
  disadvantage("Stubbornness", points: -5),
  quirk("Never hurries"),
  skill("Hiking", 14, "HT/A"),
  skill("Fast-Talk", 12, "IQ/A"),
  skill("Survival (Woodlands)", 11, "Per/A"),
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
  skill("Running", 16, "HT/A"),
  melee-attack("Kick", 13, [#dice(..thrust(6)) cr], reach: "C"),
)

// The odds in the designer's note, in per cent. They are calculated,
// not playtested.
#let odds = (walks: 26, hedge: 37, taunt: 45, both: 57, awake: 79, asleep: 86)

// The player builds the Tortoise on 50 points. Compilation stops if a
// change makes it cost more.
#assert(total-points(tortoise) <= 50, message: "The Tortoise is over 50 points")

#block(
  fill: accent.lighten(88%),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
  text(size: 8.5pt)[
    *An example, not a tested adventure.* This one-shot shows what the
    `gurps-ink` package can do: stat blocks, dice, book references and
    the #sjgames notices. Nobody has playtested it. Check the numbers
    before you use it at your table.
  ],
)

#align(center)[
  #text(size: 22pt, fill: accent, weight: "bold")[The Tortoise \ and the Hare]
  #v(2pt)
  #text(size: 11pt)[A one-shot adventure for #gurps Fourth Edition]
  #v(4pt)
  One player and a GM #sym.dot.c About 45 minutes #sym.dot.c A
  #total-points(tortoise)-point hero
]

#v(6pt)

= Introduction

Everybody knows how this race ends. Or do they? In this one-shot, the
oldest race in the world is run again, and this time the dice decide.
One player is the Tortoise: slow, stubborn and very hard to stop. The GM
plays the Hare: the fastest animal in the meadow, and the first to say
so.

The adventure is short. It fits in a lunch break. It needs one player, one GM, three six-sided dice and the
#gurps-book("Basic Set"). New players learn Quick Contests and
self-control rolls.

#aside(
  source: [Aesop, "The Hare and the Tortoise", translated by George Fyler
    Townsend (1867). Each quotation in this style is from this fable.],
)[
  A Hare one day ridiculed the short feet and slow pace of the Tortoise,
  who replied, laughing: "Though you be swift as the wind, I will beat you
  in a race."
]

== How to Use This Adventure

Read it once before you play. Give the player the Tortoise's stat block,
or let the player build a Tortoise on #total-points(tortoise) points. Then
read "The Challenge" aloud, and play the race.

= The Meadow

The meadow lies between the old oak and the mill pond. Rabbits, mice and
a very old Fox live there. Nothing much happens in the meadow, and the
animals like it that way. Then the Hare starts to boast.

== The Challenge

_Read aloud:_ "Under the old oak, the Hare stretches its long legs. 'Not
one of you,' it says, 'could beat me from here to the mill pond.' The
mice look away. The rabbits look at their feet. Then a slow voice comes
from the grass: 'I could.'"

The Hare laughs so hard that it falls over. Then it accepts.

#aside[
  The Hare, believing her assertion to be simply impossible, assented to
  the proposal; and they agreed that the Fox should choose the course and
  fix the goal.
]

= The Racers

== The Tortoise

The Tortoise has a shell like a cobblestone and a will like a mule. It
cannot run at all. It walks, it does not stop and it does not tire: that
is its Hiking skill.

#block(breakable: false, stat-block(tortoise))

== The Hare

The Hare is the fastest animal in the meadow. It also has Overconfidence
(#basic-set(148)): it cannot believe that it could lose.

#block(breakable: false, stat-block(hare))

= The Course

The Fox walks the course and plants a feather at the goal. It is one
mile long and has three landmarks.

- *The clover patch.* Halfway. The clover is sweet and the sun is warm.
  It is a very good place for a nap.
- *The hedge.* A thick hawthorn hedge with one small gap at the bottom.
  At SM #level-of(tortoise, "SM"), the Tortoise fits through the gap. At
  SM #level-of(hare, "SM"), the Hare does not, and must run around.
- *The mill pond.* The goal. The Fox waits there to judge the finish.

= The Race

#aside[
  The Tortoise never for a moment stopped, but went on with a slow but
  steady pace straight to the end of the course.
]

Play the race in three steps.

+ *Taunt (optional).* At the start, the Tortoise can mock the Hare. Roll
  a Quick Contest (#basic-set(348)) of the Tortoise's
  Fast-Talk-#level-of(tortoise, "Fast-Talk") against the Hare's Will of
  #level-of(hare, "Will"). If the Tortoise wins, the Hare takes −4 on its
  roll in step 2.
+ *The nap.* At the clover patch, the Hare is far ahead. The GM rolls
  #dice(3) against the Hare's self-control number of 12 (#basic-set(120)). On a
  failure, the Hare lies down for a nap.
+ *The finish.* Roll a Quick Contest: the Tortoise's
  Hiking-#level-of(tortoise, "Hiking") (#basic-set(200)) against the Hare's
  Running-#level-of(hare, "Running") (#basic-set(218)). The Hare gets +4 for its
  speed. If it took a nap, it gets −4 instead. If the player says that
  the Tortoise uses the gap in the hedge, the Tortoise gets +2. The
  winner reaches the pond first. On a tie, the Tortoise wins by the
  length of its nose.

*Designer's note.* These odds are calculated, not playtested. If the
player only walks, the Tortoise wins #odds.walks% of races. With the
hedge, it wins #odds.hedge%. With the taunt, #odds.taunt%. With the
taunt and the hedge, #odds.both%. Even against the hedge, an awake Hare
wins #odds.awake% of races, and a sleeping Hare loses #odds.asleep%.
Clever play pays, as it should.

#aside[
  The Hare, lying down by the wayside, fell fast asleep.
]

= After the Race

If the Tortoise wins, the meadow cheers, and the Hare is quiet for a
whole week. If the Hare wins, it boasts until the leaves fall. Either
way, the story is over: this one-shot does not lead to a campaign.

#aside[Slow but steady wins the race.]

== Variations

- *More players.* Each extra player is another slow animal: a snail, a
  hedgehog or a mole. Each one rolls its own Quick Contest against the
  Hare.
- *A rematch.* The Hare has learned its lesson. It has no Overconfidence,
  so skip step 2. Can the Tortoise still win?

#pagebreak()

= About This Adventure

#set text(size: 8pt)

*Author.* Nathanael Farley, October 2026.

*Use of AI.* Claude Opus 5.5, an AI model by Anthropic, was used to
draft the text, the characters and the race rules, to calculate the
odds, and to typeset the adventure. Nathanael Farley gave the
directions and reviewed the result.

*Tools.* Typeset with #link("https://typst.app")[Typst] and
#link("https://github.com/natfarleydev/gurps-typst")[`gurps-ink`]
0.1.0. The source of this adventure is `docs/example/tortoise-and-hare.typ`
in the `gurps-ink` repository. The odds in the designer's note were
calculated exactly from the rules; `docs/example/odds.typ` shows how.

*References.*
- Aesop, "The Hare and the Tortoise", in _Aesop's Fables_, translated by
  George Fyler Townsend (1867). Public domain. The italic quotations
  come from this translation.
- #gurps-book("Basic Set"), Fourth Edition, #sjgames. Rules cited:
  self-control rolls (#basic-set(120)), Overconfidence (#basic-set(148)), Hiking
  (#basic-set(200)), Running (#basic-set(218)), Quick Contests (#basic-set(348)).
- #sjgames,
  #link("https://www.sjgames.com/general/online_policy.html")[Online
    Policy]: the disclaimer and the notice below.
- #sjgames,
  #link("https://www.sjgames.com/general/guidelines/authors/style.html")[Authors'
    Guidelines: Editorial Style]: dice, book titles and page references.

#v(1fr)
#line(length: 100%, stroke: 0.4pt + accent)
#set text(size: 7pt)

#sjgames-disclaimer

#sjgames-notice
