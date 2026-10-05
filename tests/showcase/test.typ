// End-to-end port of the LaTeX package's test document. Persistent
// reference: inspect ref/*.png when updating.
#import "/src/lib.typ": *
#set page(width: 14cm, height: auto, margin: 5mm)

= Dice notation demo

#gurps is an excellent RPG system which can be typeset with Typst! It uses
six-sided dice which are notated as #dice($n$, $m$), e.g. #dice(3),
#dice(4, 0), #dice(2, -1), #dice(7, 11). Rules live in
#gurps-book("Basic Set", 16).

= A character appears

#let foo = character(
  name: "Foo Bar",
  st: 11, iq: 12, dx: 8, per: 15,
  advantage("Zoology"),
  advantage("Typesetting skills", 15),
  disadvantage("Fear of lions"),
  disadvantage("Bugs"),
  disadvantage("Apathy"),
  advantage("Typst wizardry", level: 3),
  skill("Foo-barring", 12),
  skill("Typstpert!", 16, "IQ/Wildcard"),
  skill("Computer Operation (Typst)", 16, "Typstpert!/Hard"),
  spell(`#set`, 16),
  melee-attack("Punch keyboard", 18, [#dice(5) cr], reach: "C, 1", notes: [Believe it!]),
  melee-attack("Slam keyboard", 16, [#dice(10) cr], reach: "C, 1", notes: [Believe it _more!_]),
  ranged-attack("Throw keyboard", 21, [#dice(1) cr], range: "100/1000", notes: [ARRRGGGG!]),
)
#stat-block(foo)

Foo Bar has ST #level-of(foo, "ST"), Dodge #level-of(foo, "Dodge") and
#total-points(foo) points.

= Various disclaimers

#sjgames-disclaimer

#sjgames-notice

#sjgames-game-aid[Nathanael Farley]
