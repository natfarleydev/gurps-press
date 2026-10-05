// skill() parses its cost; character() turns base/difficulty into points.
#import "/src/lib.typ": *

#let s = skill("Stealth", 12, "DX/A")
#assert.eq(s.kind, "skill")
#assert.eq(s.level, 12)
#assert.eq(s.base, "DX")
#assert.eq(s.difficulty, "A")
#assert.eq(s.points, none)
#assert.eq(skill("Brawling", 14, 4).points, 4)
#assert.eq(skill("Carousing", 10).points, none)
#assert.eq(skill("Carousing", 10).base, none)
// Long difficulty names and spacing are accepted.
#assert.eq(skill("X", 10, "IQ/Very Hard").difficulty, "VH")
#assert.eq(skill("X", 10, "IQ / Wildcard").difficulty, "W")
#assert.eq(skill("X", 10, "Per/Easy").base, "Per")
#assert.eq(spell("Fireball", 14, "IQ/H").kind, "spell")

#assert-panic(() => skill("X", 10, "DX/Q"))
#assert(catch(() => skill("X", 10, "DX/Q")).contains("difficulty"))
#assert-panic(() => skill("X", 10, "DX"))
#assert-panic(() => skill("X", 10.5, 2))

// Points from relative level (all attributes 10 here).
#let pts(level, cost) = character(skill("S", level, cost)).skills.first().points
// Easy
#assert.eq(pts(10, "DX/E"), 1)
#assert.eq(pts(11, "DX/E"), 2)
#assert.eq(pts(12, "DX/E"), 4)
#assert.eq(pts(13, "DX/E"), 8)
#assert.eq(pts(16, "DX/E"), 20)
// Average
#assert.eq(pts(9, "IQ/A"), 1)
#assert.eq(pts(10, "IQ/A"), 2)
#assert.eq(pts(11, "IQ/A"), 4)
#assert.eq(pts(12, "IQ/A"), 8)
// Hard
#assert.eq(pts(8, "IQ/H"), 1)
#assert.eq(pts(10, "IQ/H"), 4)
#assert.eq(pts(12, "IQ/H"), 12)
// Very Hard
#assert.eq(pts(7, "IQ/VH"), 1)
#assert.eq(pts(10, "IQ/VH"), 8)
// Wildcard: Very Hard ×3
#assert.eq(pts(7, "IQ/W"), 3)
#assert.eq(pts(10, "IQ/W"), 24)
// Explicit points are kept.
#assert.eq(pts(10, 7), 7)

// Base on a higher attribute, and on another skill.
#let c = character(
  iq: 12,
  skill("TeXpert", 16, "IQ/W"),
  skill("Computer Operation", 16, "TeXpert/H"),
  spell("Light", 12, "IQ/H"),
)
#assert.eq(c.skills.find(s => s.name == "TeXpert").points, 72) // VH at IQ+4 is 24, ×3
#assert.eq(c.skills.find(s => s.name == "Computer Operation").points, 4)
#assert.eq(c.spells.first().points, 4)

// Secondary characteristics can be bases too.
#assert.eq(character(per: 12, skill("Observation", 12, "Per/A")).skills.first().points, 2)

// Unknown base and unaffordable levels fail loudly.
#assert-panic(() => character(skill("S", 10, "Nope/E")))
#assert(catch(() => character(skill("S", 10, "Nope/E"))).contains("Nope"))
#assert-panic(() => character(skill("S", 8, "DX/E")))
#assert(catch(() => character(skill("S", 8, "DX/E"))).contains("too low"))
