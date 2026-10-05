// Building characters: trait constructors and point-cost calculations.
//
// Everything here returns plain dictionaries. Rendering lives in
// stat-block.typ.

#import "util.typ": plain-text, take-optional
#import "damage.typ": swing, thrust

// --- Validation helpers (private) -----------------------------------------

#let check-name(name, caller) = {
  if type(name) not in (str, content) {
    panic(caller + "() name must be a string or content, got " + repr(name))
  }
}

#let check-int(value, caller, what) = {
  if type(value) != int {
    panic(caller + "() " + what + " must be an integer, got " + repr(value))
  }
}

#let check-optional-text(value, caller, what) = {
  if value != none and type(value) not in (str, content) {
    panic(
      caller
        + "() "
        + what
        + " must be a string, content or none, got "
        + repr(value),
    )
  }
}

#let trait(kind, name, points, level) = {
  check-name(name, kind)
  if points != none { check-int(points, kind, "points") }
  if level != none { check-int(level, kind, "level") }
  (kind: kind, name: name, points: points, level: level)
}

// --- Traits ---------------------------------------------------------------

/// An advantage.
///
/// ```example
/// #let afro = advantage("Natural afro", points: 1)
/// #let magery = advantage("Magery", points: 25, level: 2)
/// #afro.points, #magery.level
/// ```
///
/// -> dictionary
#let advantage(
  /// -> str | content
  name,
  /// Point cost. Shown as `[?]` and counted as 0 when `none`.
  /// -> int | none
  points: none,
  /// Level for levelled advantages, e.g. `Magery 2`.
  /// -> int | none
  level: none,
) = trait("advantage", name, points, level)

/// A disadvantage. The point cost, if given, must be zero or negative.
///
/// ```example
/// #disadvantage("Bad Temper", points: -10).points
/// ```
///
/// -> dictionary
#let disadvantage(
  /// -> str | content
  name,
  /// Point cost (≤ 0). Shown as `[?]` and counted as 0 when `none`.
  /// -> int | none
  points: none,
  /// Level for levelled disadvantages.
  /// -> int | none
  level: none,
) = {
  let d = trait("disadvantage", name, points, level)
  if d.points != none and d.points > 0 {
    panic(
      "disadvantage() points must be zero or negative, got "
        + str(d.points)
        + " for "
        + repr(plain-text(name))
        + ". Write points: -"
        + str(d.points)
        + ".",
    )
  }
  d
}

/// A perk. Always costs 1 point.
///
/// -> dictionary
#let perk(
  /// -> str | content
  name,
) = trait("perk", name, 1, none)

/// A quirk. Always costs −1 point.
///
/// -> dictionary
#let quirk(
  /// -> str | content
  name,
) = trait("quirk", name, -1, none)

// --- Skills and spells ----------------------------------------------------

// Accepted spellings (lower case) of each difficulty, and its offset: how
// far below the base the cheapest (1 point) level is.
#let difficulty-names = (
  e: "E",
  easy: "E",
  a: "A",
  average: "A",
  h: "H",
  hard: "H",
  vh: "VH",
  "very hard": "VH",
  w: "W",
  wildcard: "W",
)
#let difficulty-offset = (E: 0, A: 1, H: 2, VH: 3, W: 3)

#let skill-like(kind, name, level, cost) = {
  check-name(name, kind)
  check-int(level, kind, "level")
  let cost = take-optional(cost, kind, "cost")
  let (points, base, difficulty) = (none, none, none)
  if type(cost) == int {
    points = cost
  } else if type(cost) == str {
    let parts = cost.split("/")
    if parts.len() < 2 {
      panic(
        kind
          + "() cost must be points or \"<base>/<difficulty>\" such as "
          + "\"DX/A\", got "
          + repr(cost),
      )
    }
    base = parts.slice(0, -1).join("/").trim()
    let given = parts.last().trim()
    difficulty = difficulty-names.at(lower(given), default: none)
    if difficulty == none {
      panic(
        kind
          + "() unknown difficulty "
          + repr(given)
          + " in "
          + repr(cost)
          + "; use E, A, H, VH or W (or Easy, Average, Hard, Very Hard, Wildcard)",
      )
    }
  } else if cost != none {
    panic(
      kind
        + "() cost must be an integer or a string like \"DX/A\", got "
        + repr(cost),
    )
  }
  (
    kind: kind,
    name: name,
    level: level,
    points: points,
    base: base,
    difficulty: difficulty,
  )
}

/// A skill at a given level.
///
/// The third argument says what the skill costs. Either give the points
/// directly, or give the controlling attribute and difficulty as GURPS
/// writes them (`"DX/E"`, `"IQ/VH"`, `"Per/Average"`) and the cost is
/// worked out by @character. The base may also be another skill or spell on
/// the same character (`"Typst/H"`); it is matched against the plain text
/// of skill and spell names, so `[_Typst_]` matches `"Typst"`. Give a skill
/// a string name if other skills are based on it and its name is mostly
/// formatting or symbols. Difficulties: `E`/`Easy`, `A`/`Average`, `H`/`Hard`,
/// `VH`/`Very Hard`, `W`/`Wildcard`.
///
/// ```example
/// #skill("Stealth", 12, "DX/A") \
/// #skill("Brawling", 14, 4) \
/// #skill("Carousing", 10)
/// ```
///
/// -> dictionary
#let skill(
  /// -> str | content
  name,
  /// Effective skill level.
  /// -> int
  level,
  /// Optional cost: points, or `"<base>/<difficulty>"`.
  /// -> int | str
  ..cost,
) = skill-like("skill", name, level, cost)

/// A spell. Works exactly like @skill.
///
/// ```example
/// #spell("Fireball", 14, "IQ/H")
/// ```
///
/// -> dictionary
#let spell(
  /// -> str | content
  name,
  /// -> int
  level,
  /// -> int | str
  ..cost,
) = skill-like("spell", name, level, cost)

// --- Attacks --------------------------------------------------------------

#let attack(kind, name, level, damage, distance-key, distance, notes) = {
  check-name(name, kind)
  check-int(level, kind, "level")
  if type(damage) not in (str, content) {
    panic(kind + "() damage must be a string or content, got " + repr(damage))
  }
  check-optional-text(distance, kind, distance-key)
  check-optional-text(notes, kind, "notes")
  let a = (kind: kind, name: name, level: level, damage: damage, notes: notes)
  a.insert(distance-key, distance)
  a
}

/// A melee attack.
///
/// ```example
/// #melee-attack("Punch", 18, [#dice(1, -1) cr], reach: "C")
/// ```
///
/// -> dictionary
#let melee-attack(
  /// -> str | content
  name,
  /// Effective skill with the attack.
  /// -> int
  level,
  /// Damage, e.g. `[#dice(2, 1) cut]`.
  /// -> str | content
  damage,
  /// -> str | content | none
  reach: none,
  /// Free-form notes printed after the attack.
  /// -> str | content | none
  notes: none,
) = attack("melee-attack", name, level, damage, "reach", reach, notes)

/// A ranged attack.
///
/// ```example
/// #ranged-attack("Bow", 14, [#dice(1, 2) imp], range: "150/200")
/// ```
///
/// -> dictionary
#let ranged-attack(
  /// -> str | content
  name,
  /// -> int
  level,
  /// -> str | content
  damage,
  /// -> str | content | none
  range: none,
  /// -> str | content | none
  notes: none,
) = attack("ranged-attack", name, level, damage, "range", range, notes)

// --- Characters -----------------------------------------------------------

// Where each kind of trait is filed on a character.
#let list-for-kind = (
  advantage: "advantages",
  perk: "perks",
  disadvantage: "disadvantages",
  quirk: "quirks",
  skill: "skills",
  spell: "spells",
  melee-attack: "attacks",
  ranged-attack: "attacks",
)

// Resolves an attribute argument (auto, a level, or a (level:, points:)
// dictionary) against its default and cost per level.
#let attribute(arg, value, default, cost-per-level, numeric: (int,)) = {
  let (level, points) = (auto, auto)
  if value == auto {
    level = default
  } else if type(value) == dictionary {
    let unknown = value.keys().filter(k => k not in ("level", "points"))
    if unknown.len() > 0 or "level" not in value {
      panic(
        "character() "
          + arg
          + " dictionary must look like (level: …, points: …), got "
          + repr(value),
      )
    }
    level = value.level
    points = value.at("points", default: auto)
    if points != auto { check-int(points, "character", arg + " points") }
  } else {
    level = value
  }
  if type(level) not in numeric {
    panic("character() " + arg + " must be an integer, got " + repr(level))
  }
  if points == auto { points = int((level - default) * cost-per-level) }
  (level: level, points: points)
}

// Point cost of a skill or spell from its relative level (Basic Set p. B170).
#let skill-points(s, base-level) = {
  let d = difficulty-offset.at(s.difficulty)
  let relative = s.level - base-level
  if relative < -d {
    panic(
      s.kind
        + " "
        + repr(plain-text(s.name))
        + " at "
        + str(s.level)
        + " is too low to buy: with "
        + s.base
        + "/"
        + s.difficulty
        + " the lowest level is "
        + str(base-level - d)
        + ". Give the points explicitly or leave the cost out.",
    )
  }
  let points = if relative == -d { 1 } else if relative == 1 - d { 2 } else {
    (relative - 1 + d) * 4
  }
  if s.difficulty == "W" { points * 3 } else { points }
}

/// Builds a character. Only state what differs from the defaults: an
/// average human (all attributes 10) is `character()`.
///
/// Every attribute argument takes a level, or a dictionary
/// `(level: …, points: …)` to override the calculated cost (useful for
/// discounts such as SM-reduced ST). Defaults and costs follow the Basic
/// Set:
///
/// #table(
///   columns: 3,
///   [*Argument*], [*Default*], [*Cost per level*],
///   [`st`, `ht`], [10], [10],
///   [`dx`, `iq`], [10], [20],
///   [`hp`], [ST], [2],
///   [`will`, `per`], [IQ], [5],
///   [`fp`], [HT], [3],
///   [`basic-speed`], [(DX+HT)/4], [20 per 1.00],
///   [`basic-move`], [⌊Basic Speed⌋], [5],
/// )
///
/// Traits, skills, spells and attacks are passed as positional arguments.
///
/// ```example
/// #let napoleon = character(
///   name: "Napoleon",
///   st: 9, hp: 12,
///   advantage("Natural afro", points: 1),
///   quirk("Big teeth"),
///   skill("Nunchuck", 16, "DX/E"),
/// )
/// #napoleon.attributes.HP \
/// #total-points(napoleon) points
/// ```
///
/// The result is a plain dictionary, and its shape is public API: read it
/// directly, or with @level-of, to quote numbers or write your own
/// renderer. It has these keys:
///
/// - `kind`: `"character"`; `name`.
/// - `attributes`: keyed `ST`, `DX`, `IQ`, `HT`, `HP`, `Will`, `Per`, `FP`,
///   `Basic Speed`, `Basic Move`, in that order; each `(level:, points:)`.
/// - `dodge`, `sm`, `dr`, `thr`, `sw`: as given or calculated.
/// - `advantages`, `perks`, `disadvantages`, `quirks`: arrays of
///   `(kind:, name:, points:, level:)` in the order given.
/// - `skills`, `spells`: arrays of `(kind:, name:, level:, points:, base:,
///   difficulty:)`, with `points` worked out where a base was given.
/// - `attacks`: arrays of `(kind:, name:, level:, damage:, notes:)` plus
///   `reach` (melee) or `range` (ranged).
///
/// Unknown values are `none`.
///
/// -> dictionary
#let character(
  /// Shown as the stat block title.
  /// -> str | content | none
  name: none,
  /// -> int | dictionary
  st: 10,
  /// -> int | dictionary
  dx: 10,
  /// -> int | dictionary
  iq: 10,
  /// -> int | dictionary
  ht: 10,
  /// -> auto | int | dictionary
  hp: auto,
  /// -> auto | int | dictionary
  will: auto,
  /// -> auto | int | dictionary
  per: auto,
  /// -> auto | int | dictionary
  fp: auto,
  /// In steps of 0.25.
  /// -> auto | int | float | dictionary
  basic-speed: auto,
  /// -> auto | int | dictionary
  basic-move: auto,
  /// Defaults to ⌊Basic Speed⌋ + 3. Has no point cost.
  /// -> auto | int
  dodge: auto,
  /// Size Modifier.
  /// -> int
  sm: 0,
  /// Damage Resistance, e.g. `2` or `[3 (torso only)]`.
  /// -> int | str | content
  dr: 0,
  /// Thrust damage: a `(count, modifier)` pair or content. Defaults to
  /// @thrust of ST.
  /// -> auto | array | content
  thr: auto,
  /// Swing damage, like `thr`. Defaults to @swing of ST.
  /// -> auto | array | content
  sw: auto,
  /// Results of @advantage, @disadvantage, @perk, @quirk, @skill, @spell,
  /// @melee-attack and @ranged-attack, in any order.
  /// -> dictionary
  ..traits,
) = {
  let unknown = traits.named().keys()
  if unknown.len() > 0 {
    panic(
      "character() got unknown argument(s): "
        + unknown.join(", ")
        + ". Attributes are st, dx, iq, ht, hp, will, per, fp, basic-speed, "
        + "basic-move, dodge, sm, dr, thr, sw.",
    )
  }
  if name != none { check-name(name, "character") }

  // Attributes, in stat-block order. Each default depends on earlier ones.
  let a = (:)
  a.ST = attribute("st", st, 10, 10)
  a.DX = attribute("dx", dx, 10, 20)
  a.IQ = attribute("iq", iq, 10, 20)
  a.HT = attribute("ht", ht, 10, 10)
  a.HP = attribute("hp", hp, a.ST.level, 2)
  a.Will = attribute("will", will, a.IQ.level, 5)
  a.Per = attribute("per", per, a.IQ.level, 5)
  a.FP = attribute("fp", fp, a.HT.level, 3)
  let speed = attribute(
    "basic-speed",
    basic-speed,
    (a.DX.level + a.HT.level) / 4,
    20,
    numeric: (int, float),
  )
  if calc.fract(speed.level * 4) != 0 {
    panic(
      "character() basic-speed must be a multiple of 0.25, got "
        + repr(speed.level),
    )
  }
  a.insert("Basic Speed", (level: float(speed.level), points: speed.points))
  let speed-floor = int(calc.floor(speed.level))
  a.insert("Basic Move", attribute("basic-move", basic-move, speed-floor, 5))

  let c = (
    kind: "character",
    name: name,
    attributes: a,
    dodge: if dodge == auto { speed-floor + 3 } else {
      check-int(dodge, "character", "dodge")
      dodge
    },
    sm: {
      check-int(sm, "character", "sm")
      sm
    },
    dr: dr,
    thr: if thr == auto { thrust(a.ST.level) } else { thr },
    sw: if sw == auto { swing(a.ST.level) } else { sw },
    advantages: (),
    perks: (),
    disadvantages: (),
    quirks: (),
    skills: (),
    spells: (),
    attacks: (),
  )

  for t in traits.pos() {
    let list = if type(t) == dictionary {
      list-for-kind.at(t.at("kind", default: ""), default: none)
    }
    if list == none {
      let hint = if type(t) in (str, content) {
        " Did you mean name: " + repr(t) + "?"
      } else { "" }
      panic(
        "character() takes traits from advantage(), skill(), melee-attack() etc. "
          + "as positional arguments, got "
          + repr(t)
          + "."
          + hint,
      )
    }
    c.at(list).push(t)
  }

  // Work out skill and spell costs given as "<base>/<difficulty>". A base
  // is an attribute, or a skill or spell found by the plain text of its name.
  let named = (c.skills + c.spells).map(o => (plain-text(o.name), o))
  let base-level(s) = {
    if s.base in a { return a.at(s.base).level }
    let found = named.filter(((name, _)) => name == s.base)
    let what = s.kind + " " + repr(plain-text(s.name))
    if found.len() > 1 {
      panic(
        "cannot work out the cost of "
          + what
          + ": more than one skill or spell is called "
          + repr(s.base)
          + ". Rename one, or give the points explicitly.",
      )
    }
    if found.len() == 0 {
      let blank = named.filter(((name, _)) => name.trim() == "")
      let hint = if blank.len() > 0 {
        (
          " "
            + str(blank.len())
            + " skill(s) or spell(s) have no plain text in their "
            + "name and can never match: give them a string name."
        )
      } else { "" }
      panic(
        "cannot work out the cost of "
          + what
          + ": no attribute, skill or spell called "
          + repr(s.base)
          + ". Attributes: "
          + a.keys().join(", ")
          + ". Skills and spells: "
          + named.map(((name, _)) => repr(name)).join(", ")
          + "."
          + hint,
      )
    }
    let (_, base) = found.first()
    base.level
  }
  for list in ("skills", "spells") {
    c.at(list) = c
      .at(list)
      .map(s => {
        if s.difficulty != none and s.points == none {
          s.points = skill-points(s, base-level(s))
        }
        s
      })
  }
  c
}

// --- Reading characters ---------------------------------------------------

/// The level of an attribute, skill or spell, looked up by name (skills
/// and spells by the plain text of theirs). Also knows `"Dodge"` and
/// `"SM"`. Panics, listing what exists, if the name is unknown, and if more
/// than one attribute, skill or spell has that name.
///
/// ```example
/// #let c = character(dx: 12, skill("Stealth", 13, "DX/A"))
/// #level-of(c, "Basic Speed"), #level-of(c, "Stealth")
/// ```
///
/// -> int | float
#let level-of(
  /// A result of @character.
  /// -> dictionary
  char,
  /// e.g. `"ST"`, `"Basic Move"`, `"Stealth"`.
  /// -> str
  name,
) = {
  let levels = char.attributes.pairs().map(((k, v)) => (k, v.level))
  levels += (("Dodge", char.dodge), ("SM", char.sm))
  levels += (char.skills + char.spells).map(s => (plain-text(s.name), s.level))
  let found = levels.filter(((k, _)) => k == name)
  if found.len() == 0 {
    panic(
      "level-of(): no attribute, skill or spell called "
        + repr(name)
        + ". Known: "
        + levels.map(((k, _)) => k).join(", "),
    )
  }
  if found.len() > 1 {
    panic(
      "level-of(): more than one attribute, skill or spell is called "
        + repr(name)
        + ". Rename one so it can be looked up.",
    )
  }
  let ((_, level),) = found
  level
}

/// Total character points: the sum of every known cost. Traits without a
/// cost count as 0.
///
/// ```example
/// #total-points(character(st: 12, dx: 11))
/// ```
///
/// -> int
#let total-points(
  /// A result of @character.
  /// -> dictionary
  char,
) = {
  let costs = char.attributes.values().map(v => v.points)
  for list in (
    "advantages",
    "perks",
    "disadvantages",
    "quirks",
    "skills",
    "spells",
  ) {
    costs += char.at(list).map(t => t.points)
  }
  costs.filter(p => p != none).sum(default: 0)
}
