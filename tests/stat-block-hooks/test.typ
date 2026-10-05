// stat-block() calls its title and section hooks with the documented
// arguments and uses what they return.
#import "/src/lib.typ": *
#import "/src/util.typ": plain-text

#let c = character(
  name: "Napoleon",
  st: 9,
  advantage("Natural afro", points: 1),
  perk("Fur"),
  skill("Nunchuck", 16, "DX/E"),
  melee-attack("Punch", 18, [1d cr]),
)
#let text-of(..args) = plain-text(stat-block(c, ..args))

// title receives the character and its total, or none without points.
#let seen = text-of(title: (char, total) => {
  assert.eq(char, c)
  assert.eq(total, total-points(c))
  [TITLE #total]
})
#assert(seen.contains("TITLE " + str(total-points(c))), message: seen)
#assert(not seen.contains("Napoleon"), message: seen)
#let _ = text-of(show-points: false, title: (char, total) => {
  assert.eq(total, none)
  []
})

// Leaving the title out.
#assert(not text-of(title: none).contains("Napoleon"))
#assert(not text-of(title: (..) => none).contains("Napoleon"))

// section is called once per non-empty list, in order, with its label.
#let shown = text-of(section: (label, body) => [<#label>])
#assert(shown.contains("<Advantages><Perks><Skills><Attacks>"), message: shown)
#let body = text-of(section: (label, body) => if label == "Skills" { body })
#assert(body.contains("Nunchuck-16 [20]."), message: body)

// Wrong hook types are caught.
#assert-panic(() => stat-block(c, title: [Napoleon]))
#assert(catch(() => stat-block(c, title: [Napoleon])).contains("title"))
#assert-panic(() => stat-block(c, section: none))
#assert(catch(() => stat-block(c, section: none)).contains("section"))
