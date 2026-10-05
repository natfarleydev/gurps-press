// Source of docs/example.png, the picture in the README. Build with
// `just doc`. Keep it in sync with the README's example code.
#import "/src/lib.typ": *

#set page(width: 13cm, height: auto, margin: 6mm)
#set text(size: 10pt)

#let napoleon = character(
  name: "Napoleon",
  st: 9, hp: 12,
  advantage("Natural afro", points: 1),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  melee-attack("Punch", 18, [#dice(1, -2) cr], reach: "C",
    notes: [Believe it!]),
)

#stat-block(napoleon)

He punches for #dice(..napoleon.thr) and has
#level-of(napoleon, "Dodge") Dodge (#gurps-book("Basic Set", 16)).

#text(size: 8pt, sjgames-disclaimer)
