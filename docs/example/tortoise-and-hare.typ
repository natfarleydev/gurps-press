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
(p.~B148): it cannot believe that it could lose.

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
  a Quick Contest (p.~B348) of the Tortoise's
  Fast-Talk-#level-of(tortoise, "Fast-Talk") against the Hare's Will of
  #level-of(hare, "Will"). If the Tortoise wins, the Hare takes −4 on its
  roll in step 2.
+ *The nap.* At the clover patch, the Hare is far ahead. The GM rolls
  #dice(3) against the Hare's self-control number of 12 (p.~B120). On a
  failure, the Hare lies down for a nap.
+ *The finish.* Roll a Quick Contest: the Tortoise's
  Hiking-#level-of(tortoise, "Hiking") (p.~B200) against the Hare's
  Running-#level-of(hare, "Running") (p.~B218). The Hare gets +4 for its
  speed. If it took a nap, it gets −4 instead. If the player says that
  the Tortoise uses the gap in the hedge, the Tortoise gets +2. The
  winner reaches the pond first. On a tie, the Tortoise wins by the
  length of its nose.

*Designer's note.* These odds are calculated (see the appendix), not
playtested. If the
player only walks, the Tortoise wins about 1 race in 4. With the hedge,
a little over 1 in 3. With the taunt, nearly 1 in 2. With the taunt and
the hedge, about 6 in 10. Even against the hedge, an awake Hare wins
about 4 races in 5, and a sleeping Hare loses about 6 in 7. Clever play
pays, as it should.

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

= Appendix: The Odds

The designer's note quotes exact odds, not playtest results. This Python
program calculates them from the rules of the #gurps-book("Basic Set"):
success rolls, critical rolls and Quick Contests (p.~B348). Change the
numbers at the top to test your own version of the race.

#table(
  columns: (1fr, auto),
  stroke: none,
  inset: (x: 4pt, y: 3pt),
  table.hline(stroke: 0.4pt + accent),
  [*The player*], [*The Tortoise wins*],
  table.hline(stroke: 0.4pt + accent),
  [Only walks], [26%],
  [Uses the gap in the hedge], [37%],
  [Taunts the Hare], [45%],
  [Taunts the Hare and uses the gap], [57%],
  table.hline(stroke: 0.4pt + accent),
)

#[
  #set text(size: 7pt)
  #set par(justify: false)
  ```python
  """Exact odds for the race in The Tortoise and the Hare.

  Rules (GURPS Basic Set): a success roll is 3d against the effective
  skill; 3 and 4 always succeed, 17 fails at skill 15 or less, 18 always
  fails (p. B348). In a Quick Contest both sides roll; the one who succeeds
  by more, or fails by less, wins (p. B348). A tie in the taunt has no
  effect; a tie at the finish goes to the Tortoise.
  """

  from itertools import product

  # The numbers in the adventure.
  FAST_TALK, HARE_WILL = 12, 10  # step 1: the taunt
  TAUNT_PENALTY = 4  # to the Hare's self-control roll
  SELF_CONTROL = 12  # step 2: Overconfidence (12)
  HIKING, RUNNING = 14, 16  # step 3: the finish
  AWAKE_BONUS, NAP_PENALTY = 4, 4  # the Hare's speed, or its nap
  HEDGE_BONUS = 2  # the Tortoise uses the gap in the hedge

  P3D = {}
  for dice in product(range(1, 7), repeat=3):
      P3D[sum(dice)] = P3D.get(sum(dice), 0) + 1 / 216


  def roll(skill, total):
      """(success, margin) of one success roll."""
      if total <= 4:
          success = True
      elif total == 18 or (total == 17 and skill <= 15):
          success = False
      else:
          success = total <= skill
      return success, skill - total


  def p_success(skill):
      return sum(p for total, p in P3D.items() if roll(skill, total)[0])


  def p_first_wins_or_ties(a, b):
      """Return (P(a wins), P(tie)) in a Quick Contest of a against b."""
      win = tie = 0.0
      for ta, pa in P3D.items():
          sa, ma = roll(a, ta)
          for tb, pb in P3D.items():
              sb, mb = roll(b, tb)
              if (sa and not sb) or (sa == sb and ma > mb):
                  win += pa * pb
              elif sa == sb and ma == mb:
                  tie += pa * pb
      return win, tie


  def p_tortoise_wins(taunt, hedge):
      p_taunt = p_first_wins_or_ties(FAST_TALK, HARE_WILL)[0] if taunt else 0
      tortoise = HIKING + (HEDGE_BONUS if hedge else 0)
      total = 0.0
      for taunted, p1 in ((True, p_taunt), (False, 1 - p_taunt)):
          p_nap = 1 - p_success(SELF_CONTROL - (TAUNT_PENALTY if taunted else 0))
          for napped, p2 in ((True, p_nap), (False, 1 - p_nap)):
              hare = RUNNING + (-NAP_PENALTY if napped else AWAKE_BONUS)
              total += p1 * p2 * sum(p_first_wins_or_ties(tortoise, hare))
      return total


  if __name__ == "__main__":
      for taunt, hedge, label in (
          (False, False, "only walks"),
          (False, True, "uses the hedge"),
          (True, False, "taunts"),
          (True, True, "taunts and uses the hedge"),
      ):
          print(f"Tortoise {label}: wins {p_tortoise_wins(taunt, hedge):.0%}")
      tortoise = HIKING + HEDGE_BONUS
      awake = 1 - sum(p_first_wins_or_ties(tortoise, RUNNING + AWAKE_BONUS))
      asleep = sum(p_first_wins_or_ties(tortoise, RUNNING - NAP_PENALTY))
      print(f"Against the hedge, an awake Hare wins {awake:.0%}")
      print(f"Against the hedge, a sleeping Hare loses {asleep:.0%}")
  ```
]

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
in the `gurps-ink` repository. The appendix gives the program that
calculates the odds in the designer's note.

*References.*
- Aesop, "The Hare and the Tortoise", in _Aesop's Fables_, translated by
  George Fyler Townsend (1867). Public domain. The italic quotations
  come from this translation.
- #gurps-book("Basic Set"), Fourth Edition, #sjgames. Rules cited:
  self-control rolls (p.~B120), Overconfidence (p.~B148), Hiking
  (p.~B200), Running (p.~B218), Quick Contests (p.~B348).
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
