# Task runner: https://just.systems. Run `just` to list recipes.
# Needs typst, tytanic (`tt`), typstyle (`fmt`) and typos (`spell`).
# Packaging needs bash.

root := justfile_directory()

export TYPST_ROOT := root

[private]
default:
  @just --list --unsorted

# run the test suite (pass test names to run only those)
test *args:
  tt run --no-fail-fast {{ args }}

# regenerate reference images for persistent tests, e.g. `just update stat-block`
update *args:
  tt update {{ args }}

# build the pictures in docs/, then docs/manual.pdf (which shows some of them)
doc:
  typst compile --root . docs/readme-examples.typ "docs/readme-{p}.png" --ppi 144
  typst compile --root . docs/example/odds.typ docs/tortoise-and-hare.pdf
  typst compile --root . docs/example/odds.typ "docs/tortoise-and-hare-{p}.png" --ppi 144
  typst compile --root . docs/manual.typ docs/manual.pdf

# print the package version from typst.toml (used by CI and release)
version:
  @sed -n 's/^version[[:space:]]*=[[:space:]]*"\(.*\)"$/\1/p' typst.toml

# format all Typst files in place
fmt:
  typstyle -i src tests docs

# fail if any Typst file is not formatted (CI runs this)
fmt-check:
  typstyle --check src tests docs

# check spelling
spell:
  typos

# copy the files that get published into TARGET/gurps-ink/<version>
package target:
  ./scripts/package "{{ target }}"

# install as @local/gurps-ink:<version> to try it in your own documents
install: (package "@local")

# install as @preview/gurps-ink:<version>, to test READMEs before release
install-preview: (package "@preview")

[private]
remove target:
  ./scripts/uninstall "{{ target }}"

# remove the @local install
uninstall: (remove "@local")

# remove the @preview install
uninstall-preview: (remove "@preview")

# everything CI checks
ci: test fmt-check spell doc
