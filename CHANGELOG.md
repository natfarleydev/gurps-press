# Changelog

## [Unreleased]

### Added

- First release: `gurps`, `sjgames`, `dice`,
  `gurps-book`, SJ Games policy texts, `thrust`/`swing`, `character` with
  trait/skill/attack constructors, `stat-block`, `level-of`, `total-points`.
- `basic-set(pages)` writes Basic Set pages as "p. B348", the SJ Games
  style. `gurps-book("Basic Set", pages)` fails and points to it; a
  content title opts out.
- `gurps-book` puts a comma after the title when pages follow
  ("***GURPS Magic,*** p. 14"), as the SJ Games editorial style does.
- `stat-block` hooks `title:` and `section:` to restyle parts of the block.
- The dictionary returned by `character()` is documented public API.
- Skills and spells can be based on another skill or spell by the plain
  text of its name; duplicate or unmatchable names fail with a hint.
