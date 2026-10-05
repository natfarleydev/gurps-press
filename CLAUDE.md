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
