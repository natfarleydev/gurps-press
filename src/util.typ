// Private helpers. Not re-exported from lib.typ.

/// Reads one optional positional argument from an argument sink, so public
/// functions can offer `f(a)` and `f(a, b)` like built-ins do. Panics on
/// extra positional or unexpected named arguments.
///
/// -> any
#let take-optional(
  /// The sink, e.g. `..pages`.
  /// -> arguments
  args,
  /// Function name, for error messages.
  /// -> str
  caller,
  /// Parameter name, for error messages.
  /// -> str
  param,
  /// Value when the argument is absent.
  /// -> any
  default: none,
) = {
  let named = args.named()
  if named.len() > 0 {
    panic(
      caller
        + "() got unexpected named argument(s): "
        + named.keys().join(", "),
    )
  }
  let pos = args.pos()
  if pos.len() > 1 {
    panic(
      caller
        + "() takes at most one optional `"
        + param
        + "` argument, got "
        + str(pos.len()),
    )
  }
  if pos.len() == 1 { pos.first() } else { default }
}

/// Best-effort plain text of a string or content, for sorting and error
/// messages.
///
/// -> str
#let plain-text(
  /// -> str | content | any
  it,
) = {
  if type(it) == str { return it }
  if type(it) != content { return repr(it) }
  if it.has("text") { return plain-text(it.text) }
  if it.has("children") { return it.children.map(plain-text).join("") }
  if it.has("body") { return plain-text(it.body) }
  if it.has("child") { return plain-text(it.child) }
  if it == [ ] { return " " }
  ""
}
