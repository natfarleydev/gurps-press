// level-of() and total-points() read a finished character.
#import "/src/lib.typ": *

#let c = character(
  st: 9,
  dx: 12,
  hp: 12,
  sm: -1,
  advantage("Natural afro", points: 1),
  advantage("Zoology"),
  disadvantage("Bad Temper", points: -10),
  perk("Fur"),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  spell("Light", 10, "IQ/H"),
)
#assert.eq(level-of(c, "ST"), 9)
#assert.eq(level-of(c, "HP"), 12)
#assert.eq(level-of(c, "Basic Speed"), 5.5)
#assert.eq(level-of(c, "Dodge"), 8)
#assert.eq(level-of(c, "SM"), -1)
#assert.eq(level-of(c, "Nunchuck"), 16)
#assert.eq(level-of(c, "Light"), 10)
#assert-panic(() => level-of(c, "Nope"))
#assert(catch(() => level-of(c, "Nope")).contains("Nunchuck"))

// ST -10, DX +40, HP +6, Speed +0, afro 1, Zoology ?, temper -10, fur 1,
// teeth -1, Nunchuck (DX+4, E) 12, Light (IQ, H) 4.
#assert.eq(total-points(c), -10 + 40 + 6 + 1 - 10 + 1 - 1 + 12 + 4)
#assert.eq(total-points(character()), 0)

// A name shared by several entries is ambiguous, not "the first one".
#let twins = character(skill("Typst", 12), spell([Typst], 14))
#assert-panic(() => level-of(twins, "Typst"))
#assert(catch(() => level-of(twins, "Typst")).contains("more than one"))
#let shadow = character(per: 12, skill("Per", 9))
#assert-panic(() => level-of(shadow, "Per"))
// Other names on the same character still work.
#assert.eq(level-of(twins, "ST"), 10)
