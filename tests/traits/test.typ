// Trait constructors return plain dictionaries.
#import "/src/lib.typ": *

#let a = advantage("Natural afro", 1)
#assert.eq(a.kind, "advantage")
#assert.eq(a.name, "Natural afro")
#assert.eq(a.points, 1)
#assert.eq(a.level, none)
#assert.eq(advantage("Zoology").points, none)
#assert.eq(advantage("Magery", 25, level: 2).level, 2)
#assert.eq(advantage[Content *name*].name, [Content *name*])

#let d = disadvantage("Bad Temper", -10)
#assert.eq(d.kind, "disadvantage")
#assert.eq(d.points, -10)
#assert.eq(disadvantage("Bugs").points, none)
#assert.eq(disadvantage("Odious Habit", -5, level: 1).level, 1)
#assert-panic(() => disadvantage("Bad Temper", 10))
#assert(catch(() => disadvantage("Bad Temper", 10)).contains("negative"))

#assert.eq(perk("Fur").points, 1)
#assert.eq(perk("Fur").kind, "perk")
#assert.eq(quirk("Big teeth").points, -1)
#assert.eq(quirk("Big teeth").kind, "quirk")

#let m = melee-attack("Punch", 18, [5d cr], reach: "C, 1", notes: [Believe it!])
#assert.eq(m.kind, "melee-attack")
#assert.eq(m.level, 18)
#assert.eq(m.damage, [5d cr])
#assert.eq(m.reach, "C, 1")
#assert.eq(m.notes, [Believe it!])
#let r = ranged-attack("Bow", 14, [1d+2 imp], range: "150/200")
#assert.eq(r.kind, "ranged-attack")
#assert.eq(r.range, "150/200")
#assert.eq(r.notes, none)

// Typos are caught.
#assert-panic(() => advantage("A", 1, 2))
#assert-panic(() => advantage("A", 1.5))
#assert-panic(() => advantage("A", lvl: 2))
#assert-panic(() => melee-attack("Punch", "18", [1d]))
