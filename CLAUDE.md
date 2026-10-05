# CLAUDE.md

Guidance for AI agents (and humans) working in this repository.

## What this is

A Typst package for typesetting home-made **GURPS** material: dice notation,
book references, Steve Jackson Games online-policy boilerplate, and NPC stat
blocks with automatic point costs.

Package name on Typst Universe: `gurps-press` (Universe forbids the bare
canonical name `gurps`). Not yet submitted; see "Releasing".

## Four rules that override everything else

1. **Start from what the author wants on the page.** A GURPS author
   wants dice that read `3d−1`, a stat block whose points add up, the SJ
   Games notices. Design every feature from that intent and give it the
   interface a Typst user would expect; don't copy the shape of how some
   other tool does it.
2. **Always work test-driven.** No behaviour change lands without a test
   that failed first. The loop is: doc-comment (the spec) → failing test →
   smallest code that passes → refactor while green. Bug fix? Reproduce it
   in a test first. Refactor? The behaviour must already be covered; add
   the missing tests first. "Tests afterwards" is never acceptable, not
   even for "trivial" changes.
3. **Relentlessly pursue idiomatic Typst.** Every change, and every review
   (ours and CodeRabbit's), asks "is this how a seasoned Typst author
   would write it?" Working but awkward code gets rewritten. Concretely:
   - Read like Typst's standard library: positional arguments only for
     the obvious subject (`dice(3, -1)`, `skill(name, level, cost)`),
     named arguments for anything optional or ambiguous, `auto`/`none`
     defaults, accept `str` or `content` wherever text is expected.
   - Data in, content out: constructors return plain dictionaries; only
     rendering functions return content. No `state`, counters or
     `context` unless the feature truly needs them.
   - Use the language: `array.map`/`filter`/`find`, destructuring,
     dictionaries, `calc`, show/set rules. No string surgery or
     cleverness a newcomer could not follow. The one sanctioned piece of
     argument plumbing is `take-optional` (Typst has no optional
     positional parameters); don't add others.
4. **Be deterministic wherever we can.** A rule a tool can check is
   enforced by that tool, not written down as an instruction for a person
   or an AI reviewer to remember. Spelling is `typos`, package rules are
   `package-check`, formatting is `typstyle` (`just fmt-check`), README
   and manual examples are checked by `tests/readme`, doc-comments on the
   public API by `tests/doc-comments`, behaviour by the other tytanic
   tests, and all of it runs in CI. When a
   new rule comes up, first look for a linter, formatter, test or CI step
   that can enforce it, and add that. Only a rule no tool can check
   becomes prose (here, or as a CodeRabbit instruction), and
   `.coderabbit.yaml` has none for now.

If a request conflicts with these rules, say so and ask; don't quietly
break one.

## Layout

```
typst.toml            package manifest (name, version, exclude list)
src/lib.typ           entrypoint: ONLY re-exports the public API
src/text.typ          gurps, sjgames, dice, gurps-book, basic-set, policy texts
src/damage.typ        thrust/swing damage tables
src/character.typ     trait constructors, character(), level-of(), total-points()
src/stat-block.typ    stat-block() renderer
tests/<name>/test.typ tytanic unit tests (one directory per test)
docs/manual.typ       manual: overview, chapters, example, reference (tidy)
docs/chapters/        one file per user-guide chapter (start, legal, dice, characters)
docs/style.typ        example layout and `examples` show rule shared by the chapters
docs/example/tortoise-and-hare.typ  example one-shot; standalone and copyable
docs/example/odds.typ  the one-shot plus an appendix that calculates its odds;
                      `just doc` builds docs/tortoise-and-hare.pdf from it
docs/readme-examples.typ  renders each README ```typ block to docs/readme-<n>.png
scripts/              packaging helpers used by the Justfile and CI
```

Anything not re-exported from `src/lib.typ` is private.

## Conventions

- Formatting is whatever `typstyle` (defaults) produces: run `just fmt`.
  Names are `kebab-case` (Typst Universe recommendation).
- Every public definition has a tidy doc-comment (`///`, tidy ≥ 0.4
  syntax): description, a ```` ```example ```` block where useful,
  per-parameter docs with `-> type`, and a return `-> type`. The
  doc-comment **is the spec**. `tests/doc-comments` checks that it exists
  and ends in the return type.
- Fail loudly: invalid input panics with a message saying what was wrong and
  how to fix it. Every panic path has a test using `catch`/`assert-panic`.
- README examples import `@preview/gurps-press:<version>` (Universe needs
  that); manual examples import `@local/gurps-press:<version>`, since the
  manual assumes `just install`. Both are checked by `tests/readme`; tests
  import `/src/lib.typ`.
- Docs are for someone writing an unofficial GURPS sourcebook. They know
  GURPS; don't explain its rules. The manual is a user guide first: one
  chapter per pillar (legal notices, dice and books, characters), each
  opening with the questions it answers, each section answering one
  question with a verb heading. "Find your question" in the overview
  maps every section; add new sections there. The reference uses the same
  three groups. The Tortoise and the Hare is the running example: reuse
  it rather than inventing new characters.
- Write in ASD-STE100 style: sentences of 20 words or fewer, active
  voice, imperative for instructions, one term per thing.
- Never claim more than the sources say. The notices cite the SJ Games
  online policy (section IV; section II forbids looking like an SJ Games
  product); dice and titles cite the SJ Games Authors' Guidelines. The
  game-aid notice is a community convention, not policy text.
- In the manual, every example shows code on the left and its result on
  the right (`#show: examples` in a chapter file; tidy examples use the
  same layout). The README is Markdown: plain code blocks, with the
  picture that `just doc` renders from the first one. Re-run `just doc`
  after changing a README example or the example adventure.

## Workflow: TDD (always)

1. Write/extend the doc-comment describing the behaviour.
2. Write a failing test in `tests/` (`tt new --compile-only <name>` for logic,
   `tt new <name>` for a visual reference test, or add `ref.typ` for an
   ephemeral test comparing against hand-written expected markup).
3. Run it and watch it fail *for the right reason* (the assertion, not a
   typo). Commit it as `test: …` if that helps review.
4. Write the smallest idiomatic code that makes `just test` pass, then
   refactor while green. Commit as `feat:`/`fix:`/`refactor:`.
5. Update README and manual examples last, so they show the final API.
6. Prefer compile-only tests with `assert.eq` for logic; keep persistent PNG
   references few (they break on any layout change). Regenerate them with
   `just update <test>` and eyeball the PNG files before committing.

## Commands

Requires `typst` (0.15), `tt` (tytanic 0.4), `typstyle` (0.15), `typos`
and `just`.

```
just test            # run all tests
just update <name>   # regenerate reference images
just fmt             # format all Typst files (CI checks with fmt-check)
just doc             # build docs/manual.pdf and README example image
just install         # install as @local/gurps-press:<version>
just ci              # what CI runs
typos                # spell check (CI runs this too)
```

## Releasing

1. Bump `version` in `typst.toml`, every `@preview/gurps-press:x.y.z` import in
   README/docs/examples, and `CHANGELOG.md`.
2. `just ci`, commit, tag `vX.Y.Z`, push the tag. `release.yml` builds the
   bundle and attaches it to a GitHub release.
3. Submission to typst/packages is manual for now (copy the bundle into
   `packages/preview/gurps-press/X.Y.Z` in a fork and open a PR).

## GURPS rules encoded (Basic Set, 4th ed.)

- Attributes default 10. Cost/level: ST 10, DX 20, IQ 20, HT 10.
- HP default ST (2/lvl), Will and Per default IQ (5/lvl), FP default HT (3/lvl).
- Basic Speed default (DX+HT)/4 (20 per +1.00), Basic Move default
  floor(Basic Speed) (5/lvl), Dodge = floor(Basic Speed) + 3 (no cost).
- Skill cost from relative level r and difficulty offset d (E0 A1 H2 VH3):
  r=−d → 1, r=1−d → 2, r=2−d → 4, then +4 per level. Wildcard = VH × 3.
- Thrust/swing from the ST table (B16), ST 1–100.

## Git workflow

- Never commit to `main` directly. One branch and PR per change (`feat/…`, `fix/…`,
  `docs/…`, `refactor/…`), then open a PR with `gh pr create`; CodeRabbit
  reviews every PR with its default settings (`.coderabbit.yaml` holds no
  review instructions) and approves or requests changes.
- Commit small and often: each red→green TDD step, or each logical change,
  is its own Conventional Commit (`feat:`, `fix:`, `test:`, `docs:`, …).
- Push after every commit or two so CodeRabbit and CI see progress; don't
  sit on unpushed work.
- Address CodeRabbit comments with new commits (no force-push rewrites) and
  reply when declining a suggestion.
- Merge when CodeRabbit has approved the PR and CI is green; not before.

## Status and next steps (handover)

Last updated 2026-10-05. Pick up from here.

**Intent:** a Typst package for GURPS game aids: idiomatic Typst, TDD,
clear to a newcomer, ready for Typst Universe but not yet submitted.

**Done:** the package is feature-complete for v0.1.0 and lives in PR #1
(`feat/initial-port`). PR #2 was stacked on it and merged in; fixes for
review comments arrive the same way (a branch stacked on
`feat/initial-port`, merged when green). 18 tytanic tests pass on Typst
0.13, 0.14 and 0.15; CI, `typos` and `package-check` are green. Licence
is MIT-0 (Universe requires OSI approval, which CC0 lacks).

**Next:**
1. Merge PR #1 into `main` once CodeRabbit approves it (CI is green).
2. Cut `v0.1.0` (see "Releasing"), then submit to typst/packages.

**Later / not started:** importing characters from GCS (`.gcs` is JSON,
so `json()` it directly),
ST above 100 damage, SM-based ST cost discount (users can override
`st: (level:, points:)` for now), `stat-block` as a custom element with
show/set rules once Typst supports user-defined elements.

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
- In code blocks a newline also ends an expression: a line starting with
  `+ "..."` is a new (unary-plus) statement. Wrap multi-line string
  concatenations in parentheses.
- `catch` in Typst < 0.15 returns the message `repr`-escaped (`\"`), so
  assert on message text with quote-agnostic patterns.
- Check older Typst locally with tytanic 0.2.2 / 0.3.4 binaries before
  pushing; CI runs all three.
- Package name `gurps-press`, because Universe forbids canonical names like
  `gurps`. It is permanent once on Universe. Docs and checks read it from
  `typst.toml`; the prose mentions it by hand.
