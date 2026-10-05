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

// Copied from the doc-comment of stat-block().
#let title = (char, total) => {
  let points = if total != none [#total points]
  if char.name == none { points }
  else [#strong(char.name)#if points != none [ (#points)]]
}
#let section = (label, body) => [#strong[#label:] #body]
#let sb = stat-block.with(title: title, section: section)

#sb(napoleon)
#sb(napoleon, show-points: false)
#sb(character(), show-points: false)
