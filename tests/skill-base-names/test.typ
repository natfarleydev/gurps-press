// Skills and spells based on another skill find it by the plain text of
// its name, and fail loudly when that is not enough to tell.
#import "/src/lib.typ": *

#let points-of(c, name) = c.skills.find(s => s.name == name).points

// A formatted (content) name is found by its plain text.
#let c = character(
  iq: 12,
  skill([#strong[TeX]pert], 16, "IQ/W"),
  skill("Computer Operation", 16, "TeXpert/H"),
)
#assert.eq(points-of(c, "Computer Operation"), 4)
// Spells can be bases for skills and the other way round.
#let m = character(
  spell([_Light_], 12, "IQ/H"),
  skill("Photography", 12, "Light/A"),
)
#assert.eq(points-of(m, "Photography"), 2)

// Two skills or spells that read the same cannot be told apart.
#let twins() = character(
  skill("Typst", 12, "IQ/H"),
  spell([Typst], 12, "IQ/H"),
  skill("Typesetting", 12, "Typst/A"),
)
#assert-panic(twins)
#let msg = catch(twins)
#assert(msg.contains("Typst"), message: msg)
#assert(msg.contains("more than one"), message: msg)
// Duplicates that are never used as a base are fine.
#let _ = character(skill("Typst", 12), spell([Typst], 12))

// Typst before 0.15 escapes quotes in caught messages.
#let quoted(name) = regex("\\\\?\"" + name + "\\\\?\"")

// No match: the message lists what exists, and points out names whose
// plain text is empty, which can never match.
#let unmatched() = character(
  skill([#box(width: 1em)], 12),
  skill("Brawling", 12),
  skill("Kicking", 12, "Brawl/H"),
)
#assert-panic(unmatched)
#let msg = catch(unmatched)
#assert(msg.contains(quoted("Brawl")), message: msg)
#assert(msg.contains(quoted("Brawling")), message: msg)
#assert(msg.contains("string name"), message: msg)
// Without such names, there is no hint about string names.
#let plain = catch(() => character(skill("Brawling", 12), skill(
  "Kicking",
  12,
  "Brawl/H",
)))
#assert(plain.contains(quoted("Brawling")), message: plain)
#assert(not plain.contains("string name"), message: plain)
