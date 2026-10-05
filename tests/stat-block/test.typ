// stat-block() layout. Persistent reference: inspect ref/*.png when updating.
#import "/src/lib.typ": *
#set page(width: 12cm, height: auto, margin: 3mm)

// Everything at defaults: no empty sections, no title.
#stat-block(character())

#line(length: 100%)

// One of everything; lists come out sorted by name.
#stat-block(character(
  name: "Napoleon",
  st: 9,
  hp: 12,
  dr: [1 (glasses)],
  advantage("Natural afro", points: 1),
  advantage("Magery", points: 25, level: 2),
  advantage("Zoology"),
  perk("Fur"),
  disadvantage("Bad Temper", points: -10),
  quirk("Big teeth"),
  skill("Nunchuck", 16, "DX/E"),
  skill("Bow", 12, 4),
  spell("Light", 12, "IQ/H"),
  melee-attack("Punch", 18, [#dice(5) cr], reach: "C, 1", notes: [Believe it!]),
  ranged-attack("Throw keyboard", 21, [#dice(1) cr], range: "100/1000"),
))

#line(length: 100%)

// Points hidden.
#stat-block(show-points: false, character(
  name: [The _Thing_],
  st: 20,
  dx: 9,
  basic-speed: 5.75,
  advantage("Claws", points: 8),
  skill("Brawling", 12, "DX/E"),
))
