"""Exact odds for the race in The Tortoise and the Hare.

Run `python docs/example/race-odds.py`. The designer's note in
tortoise-and-hare.typ quotes its output. Change both together.

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
