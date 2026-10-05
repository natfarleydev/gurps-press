// stat-block()'s default hooks are exactly the ones its doc-comment shows.
// Compared against ref.typ, which spells the defaults out.
#import "/src/lib.typ": *
#set page(width: 12cm, height: auto, margin: 3mm)

#let napoleon = character(
  name: "Napoleon",
  st: 9, hp: 12,
  advantage("Natural afro", points: 1),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  melee-attack("Punch", 18, [#dice(5) cr], reach: "C, 1", notes: [Believe it!]),
  ranged-attack("Throw keyboard", 21, [#dice(1) cr], range: "100/1000"),
)

#stat-block(napoleon)
#stat-block(napoleon, show-points: false)
#stat-block(character(), show-points: false)
