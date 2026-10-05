// Rendering a character as a GURPS-style stat block.

#import "util.typ": plain-text
#import "text.typ": dice
#import "character.typ": total-points

// Basic Speed always shows two decimals, as on a character sheet.
#let format-speed(speed) = {
  let hundredths = int(calc.round(speed * 100))
  let fraction = str(calc.rem(hundredths, 100))
  str(calc.quo(hundredths, 100)) + "." + "0" * (2 - fraction.len()) + fraction
}

#let format-damage(damage) = if type(damage) == array { dice(..damage) } else { damage }

// SM is written with a sign (SM +1, SM −2) except for zero.
#let format-sm(sm) = if sm > 0 { "+" + str(sm) } else { str(sm) }

// Sort key: letters and digits only, case-insensitive (so "TeX" ≈ "tex").
#let sort-key(t) = lower(plain-text(t.name)).replace(regex("[^\p{L}\p{N}]"), "")

/// Typesets a character from @character as a stat block in the style of
/// SJ Games supplements.
///
/// Lines, in order: the title (name and total points), the four basic
/// attributes, HP/Will/Per/FP, Basic Speed/Basic Move/Dodge, SM/DR/thr/sw,
/// then labelled lists of advantages, perks, disadvantages, quirks, skills,
/// spells and attacks. Empty lists are left out. Lists are sorted by name.
/// Skills and spells read `Name-level`, as in the books.
///
/// ```example
/// #stat-block(character(
///   name: "Napoleon",
///   st: 9, hp: 12,
///   advantage("Natural afro", 1),
///   quirk("Big teeth"),
///   skill("Nunchuck", 16, "DX/E"),
///   melee-attack("Punch", 18, [#dice(5) cr], reach: "C, 1",
///     notes: [Believe it!]),
/// ))
/// ```
///
/// To frame it, wrap it: `#block(stroke: 0.5pt, inset: 8pt)[#stat-block(c)]`.
///
/// -> content
#let stat-block(
  /// A result of @character.
  /// -> dictionary
  char,
  /// Print point costs (`[10]`) and the total. Turn off for a monster
  /// manual feel.
  /// -> bool
  show-points: true,
) = {
  if type(char) != dictionary or char.at("kind", default: none) != "character" {
    panic("stat-block() expects the result of character(), got " + repr(char))
  }
  if type(show-points) != bool {
    panic("stat-block() show-points must be true or false, got " + repr(show-points))
  }

  let cost(points) = if show-points {
    [ \[#if points == none [?] else { str(points) }\]]
  }
  let attr(name, shown: auto) = {
    let a = char.attributes.at(name)
    [#name #if shown == auto { str(a.level) } else { shown }#cost(a.points)]
  }
  let sentence(items) = items.join[; ] + [.]

  let lines = ()

  if char.name != none or show-points {
    let total = if show-points [#total-points(char) points]
    lines.push(if char.name == none { total } else {
      [#strong(char.name)#if show-points [ (#total)]]
    })
  }
  lines.push(sentence(("ST", "DX", "IQ", "HT").map(attr)))
  lines.push(sentence(("HP", "Will", "Per", "FP").map(attr)))
  lines.push(sentence((
    attr("Basic Speed", shown: format-speed(char.attributes.at("Basic Speed").level)),
    attr("Basic Move"),
    [Dodge #char.dodge],
  )))
  lines.push(sentence((
    [SM #format-sm(char.sm)],
    [DR #char.dr],
    [thr #format-damage(char.thr)],
    [sw #format-damage(char.sw)],
  )))

  let trait-entry(t) = [#t.name#if t.level != none [ #t.level]#cost(t.points)]
  let skill-entry(s) = [#s.name\-#s.level#cost(s.points)]
  for (label, key, entry) in (
    ("Advantages", "advantages", trait-entry),
    ("Perks", "perks", trait-entry),
    ("Disadvantages", "disadvantages", trait-entry),
    ("Quirks", "quirks", trait-entry),
    ("Skills", "skills", skill-entry),
    ("Spells", "spells", skill-entry),
  ) {
    let items = char.at(key)
    if items.len() > 0 {
      lines.push([#strong[#label:] #sentence(items.sorted(key: sort-key).map(entry))])
    }
  }

  if char.attacks.len() > 0 {
    lines.push(strong[Attacks:])
    for a in char.attacks.sorted(key: sort-key) {
      let distance = if a.kind == "melee-attack" {
        if a.reach != none [ Reach #a.reach.]
      } else {
        if a.range != none [ Range #a.range.]
      }
      let notes = if a.notes != none [ #a.notes]
      lines.push([#h(1em)#strong[#a.name (#a.level):] #a.damage.#distance#notes])
    }
  }

  block({
    set par(first-line-indent: 0pt, hanging-indent: 1em, justify: false, spacing: 0.65em)
    lines.join(parbreak())
  })
}
