// The Tortoise and the Hare with an appendix that calculates the odds in
// its designer's note. `just doc` compiles this file to
// docs/tortoise-and-hare.pdf. The adventure itself is
// tortoise-and-hare.typ: it does not need this file.
#import "/src/lib.typ": *
#import "tortoise-and-hare.typ": accent, hare, odds, tortoise

#include "tortoise-and-hare.typ"

// The look of the adventure, for the pages after it.
#set page(paper: "a5", margin: (x: 14mm, y: 15mm), numbering: "1")
#set text(size: 9pt)
#set par(justify: true)
#show heading: set text(fill: accent)

// The odds of the race, calculated from the rules (see the appendix).
// The designer's note and the appendix print these numbers.
#let race = (
  fast-talk: level-of(tortoise, "Fast-Talk"),
  will: level-of(hare, "Will"),
  self-control: 12,
  taunt-penalty: 4,
  hiking: level-of(tortoise, "Hiking"),
  running: level-of(hare, "Running"),
  awake: 4,
  nap: 4,
  hedge: 2,
)
// ways.at(k): the number of ways that 3d shows k.
#let ways = {
  let n = (0,) * 19
  for a in range(1, 7) {
    for b in range(1, 7) {
      for c in range(1, 7) { n.at(a + b + c) += 1 }
    }
  }
  n
}
#let rolls = range(3, 19)
#let p(k) = ways.at(k) / 216
// A success roll (p. B348), with critical successes and failures.
#let succeeds(s, k) = if k <= 4 { true } else if (
  k == 18 or (k == 17 and s <= 15)
) { false } else { k <= s }
#let success-ways(s) = (
  rolls.filter(k => succeeds(s, k)).map(k => ways.at(k)).sum()
)
#let success(s) = success-ways(s) / 216
// A Quick Contest of a against b: (P(a wins), P(tie)).
#let contest(a, b) = {
  let (win, tie) = (0, 0)
  for k in rolls {
    for l in rolls {
      let (sa, sb) = (succeeds(a, k), succeeds(b, l))
      let (ma, mb) = (a - k, b - l)
      if (sa and not sb) or (sa == sb and ma > mb) {
        win += p(k) * p(l)
      } else if sa == sb and ma == mb { tie += p(k) * p(l) }
    }
  }
  (win, tie)
}
#let p-taunt = contest(race.fast-talk, race.will).first()
#let p-nap(taunted) = (
  1 - success(race.self-control - if taunted { race.taunt-penalty } else { 0 })
)
// The Tortoise wins or ties the finish.
#let finish(hedge, napped) = contest(
  race.hiking + if hedge { race.hedge } else { 0 },
  race.running + if napped { -race.nap } else { race.awake },
).sum()
#let p-win(taunt, hedge) = {
  let pt = if taunt { p-taunt } else { 0 }
  ((true, pt), (false, 1 - pt))
    .map(((t, a)) => (
      ((true, p-nap(t)), (false, 1 - p-nap(t)))
        .map(((n, b)) => a * b * finish(hedge, n))
        .sum()
    ))
    .sum()
}
#let percent(x) = str(int(calc.round(x * 100))) + "%"


// The designer's note must quote these odds.
#let calculated = (
  (
    walks: p-win(false, false),
    hedge: p-win(false, true),
    taunt: p-win(true, false),
    both: p-win(true, true),
    awake: 1 - finish(true, false),
    asleep: finish(true, true),
  )
    .pairs()
    .map(((k, v)) => (k, int(calc.round(v * 100))))
    .to-dict()
)
#assert.eq(
  calculated,
  odds,
  message: "update the odds in the designer's note of tortoise-and-hare.typ",
)

= Appendix: The Odds

The designer's note gives exact odds, not playtest results. This
appendix shows how to calculate them from the rules of the
#gurps-book("Basic Set"). Typst calculates the numbers on this page when
it typesets the adventure.

== One Roll

Three dice can show $k$ in $N(k)$ ways, out of $6^3 = 216$. For example,
$N(10) = #ways.at(10)$. So

$ P(#dice(3) = k) = N(k) / 216. $

A success roll against skill $s$ succeeds on $k <= s$, with two
exceptions (#basic-set(348)): $k <= 4$ always succeeds, and $k = 18$ (or $k = 17$
when $s <= 15$) always fails. Write $S(s)$ for the chance of success:

$ S(s) = sum_(k = 3)^18 P(#dice(3) = k) dot bb(1)[k "succeeds against" s] $

For the Hare's self-control number,
$S(#race.self-control) = #success-ways(race.self-control) / 216
approx #percent(success(race.self-control))$. After a taunt, it is
$S(#(race.self-control - race.taunt-penalty)) =
#success-ways(race.self-control - race.taunt-penalty) / 216 approx
#percent(success(race.self-control - race.taunt-penalty))$.

== Quick Contests

The margin of a roll is $m = s - k$. In a Quick Contest of skill $a$
against skill $b$, $a$ wins if only $a$ succeeds, or if both succeed or
both fail and $a$ has the larger margin. Write $W(a, b)$ for the chance
that $a$ wins or ties:

$
  W(a, b) = sum_(k = 3)^18 sum_(l = 3)^18 P(#dice(3) = k) P(#dice(3) = l)
  dot bb(1)[a "wins or ties" b]
$

== The Race

Let $t = 1$ if the taunt works, $n = 1$ if the Hare naps, and $g = 1$ if
the Tortoise uses the gap in the hedge. The taunt works with chance
$T = #percent(p-taunt)$, a Quick Contest of Fast-Talk-#race.fast-talk
against Will #race.will. Then

$ P(n = 1 | t) = 1 - S(#race.self-control - #race.taunt-penalty t) $

and the Tortoise wins the race with chance

$
  P_"win" = sum_(t in {0, 1}) sum_(n in {0, 1}) P(t) dot P(n | t) dot
  W(#race.hiking + #race.hedge g, #(race.running + race.awake) - #(race.awake + race.nap) n).
$

#table(
  columns: (1fr, auto),
  stroke: none,
  inset: (x: 4pt, y: 3pt),
  table.hline(stroke: 0.4pt + accent),
  [*The player*], [*The Tortoise wins*],
  table.hline(stroke: 0.4pt + accent),
  [Only walks], [#percent(p-win(false, false))],
  [Uses the gap in the hedge], [#percent(p-win(false, true))],
  [Taunts the Hare], [#percent(p-win(true, false))],
  [Taunts the Hare and uses the gap], [#percent(p-win(true, true))],
  table.hline(stroke: 0.4pt + accent),
)

== The Same Calculation in Python

This program gives the same numbers. Change the numbers at the top to
test your own version of the race.

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
