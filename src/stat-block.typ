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

#let format-damage(damage) = if type(damage) == array { dice(..damage) } else {
  damage
}

// SM is written with a sign (SM +1, SM −2) except for zero.
#let format-sm(sm) = if sm > 0 { "+" + str(sm) } else { str(sm) }

// The hooks' defaults, exactly as documented on stat-block().
#let default-title(char, total) = {
  let points = if total != none [#total points]
  if char.name == none { points } else [#strong(char.name)#if (
      points != none
    ) [ (#points)]]
}
#let default-section(label, body) = [#strong[#label:] #body]

// Runs a hook and checks it returned something that can go in a line.
#let call-hook(name, hook, ..args) = {
  let result = hook(..args)
  if result != none and type(result) not in (content, str) {
    panic(
      "stat-block() "
        + name
        + " hook must return content, a string or none, got "
        + repr(result)
        + ". Wrap it in brackets, e.g. [#"
        + repr(result)
        + "].",
    )
  }
  result
}

// Sort key: letters and digits only, case-insensitive (so "TeX" ≈ "tex").
#let sort-key(t) = lower(plain-text(t.name)).replace(regex("[^\p{L}\p{N}]"), "")

/// Typesets a character from @character as a stat block, in the style of
/// the SJ Games books.
///
/// The lines are: the title (name and point total), ST/DX/IQ/HT,
/// HP/Will/Per/FP, Basic Speed/Basic Move/Dodge and SM/DR/thr/sw. Then
/// come the lists: advantages, perks, disadvantages, quirks, skills,
/// spells and attacks. Each list is in alphabetical order. An empty list
/// does not show.
///
/// ```example
/// #stat-block(character(
///   name: "Napoleon",
///   st: 9, hp: 12,
///   advantage("Natural afro", points: 1),
///   quirk("Big teeth"),
///   skill("Nunchuck", 16, "DX/E"),
///   melee-attack("Punch", 18, [#dice(5) cr], reach: "C, 1",
///     notes: [Believe it!]),
/// ))
/// ```
///
/// To frame it, put it in a block:
/// `#block(stroke: 0.5pt, inset: 8pt)[#stat-block(c)]`.
///
/// Two hooks change parts of the stat block:
///
/// ```example
/// #stat-block(
///   character(name: "Guard", st: 11, skill("Spear", 12, "DX/A")),
///   title: (char, total) => smallcaps[#char.name, #total points],
///   section: (label, body) => [#emph(label) --- #body],
/// )
/// ```
///
/// For a different layout, write your own function that uses the
/// dictionary from @character. The manual shows how.
///
/// -> content
#let stat-block(
  /// A result of @character.
  /// -> dictionary
  char,
  /// Show the point costs (`[10]`) and the total. Use `false` for a
  /// handout or a bestiary.
  /// -> bool
  show-points: true,
  /// Makes the first line. The call is `title(char, total)`. `total` is
  /// the point total, or `none` if `show-points` is `false`. Return
  /// content or a string. To remove the line, return `none` or give
  /// `title: none`. `auto` is this function:
  /// ```typ
  /// (char, total) => {
  ///   let points = if total != none [#total points]
  ///   if char.name == none { points }
  ///   else [#strong(char.name)#if points != none [ (#points)]]
  /// }
  /// ```
  /// -> auto | none | function
  title: auto,
  /// Makes each list: Advantages, Perks, Disadvantages, Quirks, Skills,
  /// Spells and Attacks. The call is `section(label, body)`. `body` is the
  /// finished list: the entries, with semicolons between them and a full
  /// stop at the end. For attacks, `body` is a block with one paragraph
  /// for each attack. Return content or a string. To remove the list,
  /// return `none`. `auto` is `(label, body) => [#strong[#label:] #body]`.
  /// -> auto | function
  section: auto,
) = {
  if type(char) != dictionary or char.at("kind", default: none) != "character" {
    panic("stat-block() expects the result of character(), got " + repr(char))
  }
  if type(show-points) != bool {
    panic(
      "stat-block() show-points must be true or false, got "
        + repr(show-points),
    )
  }
  if title == auto { title = default-title }
  if section == auto { section = default-section }
  if title != none and type(title) != function {
    panic(
      "stat-block() title must be a function (char, total) => content, auto or none, got "
        + repr(title),
    )
  }
  if type(section) != function {
    panic(
      "stat-block() section must be a function (label, body) => content or auto, got "
        + repr(section),
    )
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

  if title != none {
    let heading = call-hook("title", title, char, if show-points {
      total-points(char)
    })
    if heading != none { lines.push(heading) }
  }
  lines.push(sentence(("ST", "DX", "IQ", "HT").map(attr)))
  lines.push(sentence(("HP", "Will", "Per", "FP").map(attr)))
  lines.push(sentence((
    attr("Basic Speed", shown: format-speed(
      char.attributes.at("Basic Speed").level,
    )),
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
      lines.push(call-hook("section", section, label, sentence(
        items.sorted(key: sort-key).map(entry),
      )))
    }
  }

  let attack-entry(a) = {
    let distance = if a.kind == "melee-attack" {
      if a.reach != none [ Reach #a.reach.]
    } else {
      if a.range != none [ Range #a.range.]
    }
    let notes = if a.notes != none [ #a.notes]
    [#h(1em)#strong[#a.name (#a.level):] #a.damage.#distance#notes]
  }
  if char.attacks.len() > 0 {
    let entries = char.attacks.sorted(key: sort-key).map(attack-entry)
    lines.push(call-hook("section", section, "Attacks", block(
      spacing: 0.65em,
      entries.join(parbreak()),
    )))
  }

  block({
    set par(
      first-line-indent: 0pt,
      hanging-indent: 1em,
      justify: false,
      spacing: 0.65em,
    )
    lines.join(parbreak())
  })
}
