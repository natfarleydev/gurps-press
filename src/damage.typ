// Basic damage from ST (Basic Set, p. B16).

// Rows of the table: (ST, thrust, swing), with damage as (count, modifier).
// A row applies from its ST up to the next row; this matches the B16 table,
// which lists every ST to 40 and then every 5 ST up to 100.
#let damage-table = (
  (1, (1, -6), (1, -5)),
  (3, (1, -5), (1, -4)),
  (5, (1, -4), (1, -3)),
  (7, (1, -3), (1, -2)),
  (9, (1, -2), (1, -1)),
  (10, (1, -2), (1, 0)),
  (11, (1, -1), (1, 1)),
  (12, (1, -1), (1, 2)),
  (13, (1, 0), (2, -1)),
  (14, (1, 0), (2, 0)),
  (15, (1, 1), (2, 1)),
  (16, (1, 1), (2, 2)),
  (17, (1, 2), (3, -1)),
  (18, (1, 2), (3, 0)),
  (19, (2, -1), (3, 1)),
  (20, (2, -1), (3, 2)),
  (21, (2, 0), (4, -1)),
  (22, (2, 0), (4, 0)),
  (23, (2, 1), (4, 1)),
  (24, (2, 1), (4, 2)),
  (25, (2, 2), (5, -1)),
  (26, (2, 2), (5, 0)),
  (27, (3, -1), (5, 1)),
  (29, (3, 0), (5, 2)),
  (31, (3, 1), (6, -1)),
  (33, (3, 2), (6, 0)),
  (35, (4, -1), (6, 1)),
  (37, (4, 0), (6, 2)),
  (39, (4, 1), (7, -1)),
  (45, (5, 0), (7, 1)),
  (50, (5, 2), (8, -1)),
  (55, (6, 0), (8, 1)),
  (60, (7, -1), (9, 0)),
  (65, (7, 1), (9, 2)),
  (70, (8, 0), (10, 0)),
  (75, (8, 2), (10, 2)),
  (80, (9, 0), (11, 0)),
  (85, (9, 2), (11, 2)),
  (90, (10, 0), (12, 0)),
  (95, (10, 2), (12, 2)),
  (100, (11, 0), (13, 0)),
)

// The last row whose ST is at most `st`.
#let row-for(st, caller) = {
  if type(st) != int or st < 1 or st > 100 {
    panic(
      caller
        + "() covers ST 1 to 100, got "
        + repr(st)
        + ". Set `thr:` and `sw:` on the character explicitly instead.",
    )
  }
  damage-table.filter(row => row.first() <= st).last()
}

/// The thrust damage for a ST, as a `(count, modifier)` pair. Spread it
/// into @dice.
///
/// ```example
/// #thrust(10) \
/// #dice(..thrust(10))
/// ```
///
/// It covers ST 1 to 100. Above ST 40, the Basic Set table has a row for
/// each 5 ST; between two rows, the lower row applies. For a ST that is
/// not in this range, compilation stops: give `thr:` to @character.
///
/// -> array
#let thrust(
  /// The striking strength.
  /// -> int
  st,
) = row-for(st, "thrust").at(1)

/// The swing damage for a ST, as a `(count, modifier)` pair. Spread it
/// into @dice. It covers the same ST as @thrust.
///
/// ```example
/// #dice(..swing(10))
/// ```
///
/// -> array
#let swing(
  /// The striking strength.
  /// -> int
  st,
) = row-for(st, "swing").at(2)
