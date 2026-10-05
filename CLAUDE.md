# CLAUDE.md

Guidance for AI agents (and humans) working in this repository.

## What this is

A Typst package for typesetting home-made **GURPS** material: dice notation,
book references, Steve Jackson Games online-policy boilerplate, and NPC stat
blocks with automatic point costs. It is a port of the LaTeX package
<https://github.com/natfarleydev/gurps-latex-package> — the *behaviour* is
ported, not the Lua implementation. Re-derive logic in idiomatic Typst.

Package name on Typst Universe: `gurps-ink` (Universe forbids the bare
canonical name `gurps`). Not yet submitted; see "Releasing".

## Layout

```
typst.toml            package manifest (name, version, exclude list)
src/lib.typ           entrypoint: ONLY re-exports the public API
src/text.typ          gurps, sjgames, dice, gurps-book, policy texts
src/damage.typ        thrust/swing damage tables
src/character.typ     trait constructors, character(), level-of(), total-points()
src/stat-block.typ    stat-block() renderer
tests/<name>/test.typ tytanic unit tests (one directory per test)
docs/manual.typ       manual, generated from doc-comments with tidy
examples/             example documents linked from README (excluded from bundle)
scripts/              packaging helpers used by the Justfile and CI
```

Anything not re-exported from `src/lib.typ` is private.

## Conventions

- Two-space indent, `kebab-case` names (Typst Universe recommendation).
- Every public definition has a tidy doc-comment (`///`, tidy ≥ 0.4 syntax):
  description, a ```` ```example ```` block where useful, per-parameter
  docs with `-> type`, and a return `-> type`. The doc-comment **is the spec**.
- Data in, content out: constructors return plain dictionaries; only
  `stat-block` and the text helpers produce content. No global state.
- Fail loudly: invalid input panics with a message saying what was wrong and
  how to fix it. Every panic path has a test using `catch`/`assert-panic`.
- Examples in README/docs import `@preview/gurps-ink:<version>`; tests import
  `/src/lib.typ`.

## Workflow: TDD

1. Write/extend the doc-comment describing the behaviour.
2. Write a failing test in `tests/` (`tt new --compile-only <name>` for logic,
   `tt new <name>` for a visual reference test, or add `ref.typ` for an
   ephemeral test comparing against hand-written expected markup).
3. Implement until `just test` passes.
4. Prefer compile-only tests with `assert.eq` for logic; keep persistent PNG
   references few (they break on any layout change). Regenerate them with
   `just update <test>` and eyeball the PNG files before committing.

## Commands

Requires `typst` (0.15), `tt` (tytanic 0.4) and `just`.

```
just test            # run all tests
just update <name>   # regenerate reference images
just doc             # build docs/manual.pdf and README example image
just install         # install as @local/gurps-ink:<version>
just ci              # what CI runs
typos                # spell check (CI runs this too)
```

## Releasing

1. Bump `version` in `typst.toml`, every `@preview/gurps-ink:x.y.z` import in
   README/docs/examples, and `CHANGELOG.md`.
2. `just ci`, commit, tag `vX.Y.Z`, push the tag. `release.yml` builds the
   bundle and attaches it to a GitHub release.
3. Submission to typst/packages is manual for now (copy the bundle into
   `packages/preview/gurps-ink/X.Y.Z` in a fork and open a PR).

## GURPS rules encoded (Basic Set, 4th ed.)

- Attributes default 10. Cost/level: ST 10, DX 20, IQ 20, HT 10.
- HP default ST (2/lvl), Will and Per default IQ (5/lvl), FP default HT (3/lvl).
- Basic Speed default (DX+HT)/4 (20 per +1.00), Basic Move default
  floor(Basic Speed) (5/lvl), Dodge = floor(Basic Speed) + 3 (no cost).
- Skill cost from relative level r and difficulty offset d (E0 A1 H2 VH3):
  r=−d → 1, r=1−d → 2, r=2−d → 4, then +4 per level. Wildcard = VH × 3.
- Thrust/swing from the ST table (B16), ST 1–100.

## Git workflow

- Never commit to `main` directly. Branch per change (`feat/…`, `fix/…`,
  `docs/…`, `refactor/…`), then open a PR with `gh pr create`; CodeRabbit
  reviews every PR.
- Commit small and often: each red→green TDD step, or each logical change,
  is its own Conventional Commit (`feat:`, `fix:`, `test:`, `docs:`, …).
- Push after every commit or two so CodeRabbit and CI see progress; don't
  sit on unpushed work.
- Address CodeRabbit comments with new commits (no force-push rewrites) and
  reply when declining a suggestion.
- Merge only when CI is green.

## Status and next steps (handover)

Last updated 2026-10-05. Pick up from here.

**Done** (branch `feat/initial-port`, draft PR): full port with docs-as-spec,
13 passing tytanic tests (also pass on Typst 0.13 and 0.14 locally), tidy
manual, README with compiled-example test, CI (`.github/workflows/ci.yml`),
tag-triggered release (`release.yml`, GitHub release only), CodeRabbit
config. CI and CodeRabbit have **not yet run**: check the PR first and fix
anything red (likely suspects: `taiki-e/install-action` installing
`tytanic@0.2.2`/`0.3.4`, and the `ghcr.io/typst/package-check` docker step).

**Intent:** a Typst package for GURPS game aids, ported from
gurps-latex-package by behaviour (not by Lua code), idiomatic Typst, TDD,
clear to a newcomer, ready for Typst Universe but not yet submitted. Cut a
`v0.1.0` release once the follow-ups below are merged and it looks ready.

**Follow-ups, in order, one branch + PR each** (requested by the user):

1. `refactor/named-points`: `advantage(name, points: none, level: none)` and
   `disadvantage(name, points: none, level: none)` take *named* `points:`.
   Keep `perk`/`quirk` as they are. Keep `dice(count, modifier)` and
   `skill(name, level, cost)` positional (GURPS reads them as pairs). Delete
   `take-optional` from `src/util.typ` if nothing else uses it (dice,
   gurps-book and skill still do, so probably keep). Order: docstrings
   first, then tests (traits, level-of, stat-block, showcase, README), then
   code, then README/manual examples. Commits: docs+tests (red),
   implementation (green), cleanup.
2. `feat/stat-block-hooks`: add 1–2 function hooks to `stat-block`, e.g.
   `title: (char, total) => content` and `section: (label, body) => content`,
   defaults matching current output. No theme system. Document the
   `character()` dictionary as public API; add a manual section "Writing
   your own renderer" building a block from `char.attributes` and
   `char.skills`. Note that a custom element (show/set rules) is the plan
   once Typst ships custom elements. Tests: an ephemeral test proving the
   defaults are unchanged, plus a test using each hook.
3. `fix/skill-base-names`: skills based on other skills (`"TeXpert/H"`)
   match by `plain-text(name)`, which mismatches for formatted content
   names. Document "base names are matched against the plain text of
   skill/spell names". When a base matches no attribute but some skill or
   spell name has empty or ambiguous plain text, panic with a hint to use a
   string name. Panic if two skills/spells share a plain-text name and one
   is used as a base. Tests first: content-named base that works, ambiguous
   duplicate that panics, error message text.

**Later / not started:** importing characters from GCS (`.gcs` is JSON;
the LaTeX package shelled out to `gcs`), ST above 100 damage, SM-based ST
cost discount (users can override `st: (level:, points:)` for now),
publishing via a PR to typst/packages.

**Gotchas learnt:**
- In code blocks every expression statement is joined into the result:
  validators must return `none`, not their argument.
- In markup, `#let x = f()` ends at the newline; wrap multi-line method
  chains in parentheses.
- tidy example previews need the custom style in `docs/manual.typ`
  (stacked, fixed scale) or long paragraphs shrink to nothing.
- Tytanic bundles its own Typst: tytanic 0.2.x = Typst 0.13, 0.3.x = 0.14,
  0.4.x = 0.15. Ephemeral tests' `ref/` dirs are git-ignored; persistent
  tests need a `!tests/<name>/ref/` exception in `.gitignore`.
- Package name `gurps-ink`, because Universe forbids canonical names like
  `gurps`. Change it before first submission if wanted (typst.toml, README,
  manual, tests/readme, CLAUDE.md).
