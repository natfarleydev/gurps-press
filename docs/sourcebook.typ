// The tutorial page of the manual. `just doc` compiles it to
// docs/sourcebook.png, and the manual shows this source next to that
// picture, with the import below replaced by the @preview import.
#import "/src/lib.typ": *

#set page(width: 11cm, height: 8.5cm, margin: 7mm, columns: 2)
#set text(size: 7pt)
#set par(justify: true)

#let npcs = (
  sergeant: character(
    name: "Sergeant Mara Venn",
    st: 12,
    dx: 11,
    ht: 11,
    advantage("Combat Reflexes", points: 15),
    disadvantage("Duty (City Watch)", points: -10),
    skill("Broadsword", 14, "DX/A"),
    skill("Shield", 13, "DX/E"),
    skill("Intimidation", 11, "Will/A"),
    melee-attack("Broadsword", 14, [#dice(..swing(12)) cut], reach: "1"),
  ),
  watchman: character(
    name: "Watchman",
    st: 11,
    skill("Spear", 12, "DX/A"),
    skill("Streetwise", 10, "IQ/A"),
    melee-attack("Spear", 12, [#dice(1, 1) imp], reach: "1"),
  ),
)

#place(top, float: true, scope: "parent")[= The Watch House]

The Watch keeps order in the lower city. A hero
who talks back to a guard rolls a Quick Contest
(#gurps-book("Basic Set", 348)). Sergeant Venn
swings her broadsword for #dice(..npcs.sergeant.sw) cut.

#block(breakable: false, stat-block(npcs.sergeant))

At night, two watchmen guard the door. They are
bored and easy to bribe.

#block(breakable: false, stat-block(npcs.watchman))

#text(size: 5pt)[#sjgames-disclaimer #sjgames-notice]
