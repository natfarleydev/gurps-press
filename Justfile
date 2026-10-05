# Task runner: https://just.systems. Run `just` to list recipes.
# Needs typst, tytanic (`tt`) and, for `spell`, typos. Packaging needs bash.

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

# build docs/manual.pdf and the README picture docs/example.png
doc:
  typst compile --root . docs/manual.typ docs/manual.pdf
  typst compile --root . docs/example.typ docs/example.png --ppi 144

# print the package version from typst.toml (used by CI and release)
version:
  @sed -n 's/^version[[:space:]]*=[[:space:]]*"\(.*\)"$/\1/p' typst.toml

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
ci: test spell doc
