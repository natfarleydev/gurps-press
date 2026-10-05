// The dictionaries returned by character() and the trait constructors are
// public API (documented on character()). Changing a key is a breaking
// change: update the doc-comment, this test and CHANGELOG.md together.
#import "/src/lib.typ": *

#let keys(d) = d.keys().sorted()

#let c = character(
  name: "Napoleon",
  advantage("Natural afro", points: 1),
  perk("Fur"),
  disadvantage("Bad Temper", points: -10),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  spell("Light", 10),
  melee-attack("Punch", 18, [1d cr]),
  ranged-attack("Bow", 14, [1d imp]),
)

#assert.eq(
  keys(c),
  (
    "advantages",
    "attacks",
    "attributes",
    "disadvantages",
    "dodge",
    "dr",
    "kind",
    "name",
    "perks",
    "quirks",
    "skills",
    "sm",
    "spells",
    "sw",
    "thr",
  ).sorted(),
)
#assert.eq(c.kind, "character")
#for (name, a) in c.attributes {
  assert.eq(keys(a), ("level", "points"), message: name)
}

#let trait-keys = ("kind", "level", "name", "points")
#for list in ("advantages", "perks", "disadvantages", "quirks") {
  assert.eq(keys(c.at(list).first()), trait-keys, message: list)
}
#let skill-keys = ("base", "difficulty", "kind", "level", "name", "points")
#assert.eq(keys(c.skills.first()), skill-keys)
#assert.eq(keys(c.spells.first()), skill-keys)
// Calculated costs are filled in by character().
#assert.eq(c.skills.first().points, 20)

#assert.eq(keys(c.attacks.first()), (
  "damage",
  "kind",
  "level",
  "name",
  "notes",
  "reach",
))
#assert.eq(keys(c.attacks.last()), (
  "damage",
  "kind",
  "level",
  "name",
  "notes",
  "range",
))

// The manual's "Make your own layout" example works on this contract.
#import "/src/util.typ": plain-text
#let one-liner(char) = {
  let attributes = ("ST", "DX", "IQ", "HT").map(k => [#k #(
      char.attributes.at(k).level
    )])
  let skills = char.skills.map(s => [#s.name\-#s.level])
  [*#char.name:* #attributes.join[, ]. _Skills:_ #skills.join[, ].]
}
#assert.eq(
  plain-text(one-liner(character(name: "Guard", st: 11, skill(
    "Spear",
    12,
    "DX/A",
  )))),
  "Guard: ST 11, DX 10, IQ 10, HT 10. Skills: Spear-12.",
)
