// character() fills in defaults and point costs from the Basic Set.
#import "/src/lib.typ": *

#let avg = character()
#assert.eq(avg.name, none)
#for a in ("ST", "DX", "IQ", "HT", "HP", "Will", "Per", "FP", "Basic Move") {
  let expected = if a == "Basic Move" { 5 } else { 10 }
  assert.eq(avg.attributes.at(a), (level: expected, points: 0), message: a)
}
#assert.eq(avg.attributes.at("Basic Speed"), (level: 5.0, points: 0))
#assert.eq(avg.dodge, 8)
#assert.eq(avg.sm, 0)
#assert.eq(avg.dr, 0)
#assert.eq(avg.thr, (1, -2))
#assert.eq(avg.sw, (1, 0))
#for list in ("advantages", "perks", "disadvantages", "quirks", "skills", "spells", "attacks") {
  assert.eq(avg.at(list), (), message: list)
}
// Attribute order is fixed.
#assert.eq(
  avg.attributes.keys(),
  ("ST", "DX", "IQ", "HT", "HP", "Will", "Per", "FP", "Basic Speed", "Basic Move"),
)

// Attribute costs.
#let c = character(st: 9, dx: 12, iq: 11, ht: 13)
#assert.eq(c.attributes.ST.points, -10)
#assert.eq(c.attributes.DX.points, 40)
#assert.eq(c.attributes.IQ.points, 20)
#assert.eq(c.attributes.HT.points, 30)
// Secondary defaults follow the (bought) attributes and cost nothing.
#assert.eq(c.attributes.HP, (level: 9, points: 0))
#assert.eq(c.attributes.Will, (level: 11, points: 0))
#assert.eq(c.attributes.Per, (level: 11, points: 0))
#assert.eq(c.attributes.FP, (level: 13, points: 0))
#assert.eq(c.attributes.at("Basic Speed"), (level: 6.25, points: 0))
#assert.eq(c.attributes.at("Basic Move"), (level: 6, points: 0))
#assert.eq(c.dodge, 9)
#assert.eq(c.thr, (1, -2))
#assert.eq(c.sw, (1, -1))

// Buying secondary characteristics up or down.
#let b = character(st: 9, hp: 12, will: 12, per: 9, fp: 12, basic-speed: 5.5, basic-move: 6)
#assert.eq(b.attributes.HP.points, 6)
#assert.eq(b.attributes.Will.points, 10)
#assert.eq(b.attributes.Per.points, -5)
#assert.eq(b.attributes.FP.points, 6)
#assert.eq(b.attributes.at("Basic Speed").points, 10)
// Basic Move defaults from the *bought* Basic Speed.
#assert.eq(b.attributes.at("Basic Move").points, 5)
#assert.eq(character(basic-speed: 6).attributes.at("Basic Move").level, 6)
#assert.eq(character(basic-speed: 6.75).dodge, 9)

// Explicit costs override the calculation.
#let o = character(st: (level: 13, points: 27))
#assert.eq(o.attributes.ST, (level: 13, points: 27))
#assert.eq(o.attributes.HP.level, 13)
#assert.eq(character(st: (level: 13)).attributes.ST.points, 30)

// Properties.
#let p = character(st: 13, sm: 1, dr: [3 (torso)], dodge: 10, thr: (2, 0), sw: [special])
#assert.eq(p.sm, 1)
#assert.eq(p.dr, [3 (torso)])
#assert.eq(p.dodge, 10)
#assert.eq(p.thr, (2, 0))
#assert.eq(p.sw, [special])
#assert.eq(character(st: 13).sw, (2, -1))

// Traits are sorted into their lists, in the given order.
#let t = character(
  name: "Mr. Awesome",
  advantage("B"), advantage("A"), perk("P"), disadvantage("D"), quirk("Q"),
  skill("S", 10), spell("Sp", 10), melee-attack("M", 10, [1d]),
  ranged-attack("R", 10, [1d]),
)
#assert.eq(t.name, "Mr. Awesome")
#assert.eq(t.advantages.map(x => x.name), ("B", "A"))
#assert.eq(t.perks.len(), 1)
#assert.eq(t.disadvantages.len(), 1)
#assert.eq(t.quirks.len(), 1)
#assert.eq(t.skills.len(), 1)
#assert.eq(t.spells.len(), 1)
#assert.eq(t.attacks.map(x => x.kind), ("melee-attack", "ranged-attack"))

// Mistakes are caught.
#assert-panic(() => character(strength: 10))
#assert(catch(() => character(strength: 10)).contains("strength"))
#assert-panic(() => character("Napoleon"))
#assert(catch(() => character("Napoleon")).contains("name:"))
#assert-panic(() => character(st: 9.5))
#assert-panic(() => character(basic-speed: 5.1))
#assert(catch(() => character(basic-speed: 5.1)).contains("0.25"))
#assert-panic(() => character(st: (lvl: 3)))
