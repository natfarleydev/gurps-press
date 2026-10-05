// Typographic helpers: the GURPS name, dice notation, book references and
// the Steve Jackson Games online-policy boilerplate.

#import "util.typ": take-optional

#let gurps-url = "http://www.sjgames.com/gurps/"
#let sjgames-url = "http://www.sjgames.com/"
#let online-policy-url = "http://www.sjgames.com/general/online_policy.html"

/// The name #gurps in bold italics, as the SJ Games online policy
/// requires for trademarks. Use it like any other piece of content.
///
/// ```example
/// #gurps is a generic, universal roleplaying system.
/// ```
///
/// To link it to the GURPS home page, wrap it in `link`:
/// `#link("http://www.sjgames.com/gurps/", gurps)`.
///
/// -> content
#let gurps = strong(emph[GURPS])

/// The name "Steve Jackson Games".
///
/// ```example
/// #gurps is published by #sjgames.
/// ```
///
/// -> content
#let sjgames = [Steve Jackson Games]

/// Dice in GURPS notation: the `6` of `d6` is dropped and a modifier is
/// written straight after the `d`. The result never breaks across lines.
///
/// ```example
/// #dice(3) \
/// #dice(2, 1) \
/// #dice(4, -1) \
/// #dice(1, 0)
/// ```
///
/// The modifier is optional. Zero prints nothing, negative numbers use a
/// true minus sign. Content modifiers (e.g. `$m$`) get a leading `+`.
///
/// Combine with @thrust or @swing by spreading: `#dice(..thrust(13))`.
///
/// -> content
#let dice(
  /// Number of dice. Must be a non-negative integer, or content for
  /// symbolic notation such as `$n$`.
  /// -> int | content
  count,
  /// Optional modifier added to the roll. Defaults to `0`.
  /// -> int | content
  ..modifier,
) = {
  if type(count) == int {
    if count < 0 {
      panic("dice() count must be a non-negative integer, got " + str(count))
    }
  } else if type(count) != content {
    panic("dice() count must be an int or content, got " + str(type(count)))
  }
  let modifier = take-optional(modifier, "dice", "modifier", default: 0)
  let suffix = if type(modifier) == int {
    if modifier > 0 { "+" + str(modifier) } else if modifier < 0 {
      str(modifier)
    }
  } else if type(modifier) == content {
    [+#modifier]
  } else {
    panic(
      "dice() modifier must be an int or content, got " + str(type(modifier)),
    )
  }
  box[#(count)d#suffix]
}

/// A reference to a GURPS book, in SJ Games house style: the title in bold
/// italics, optionally followed by a page reference.
///
/// ```example
/// #gurps-book("High Tech") \
/// #gurps-book("Zombies", 3) \
/// #gurps-book("Warehouse 23", "1, 3–5") \
/// #gurps-book("Basic Set", (16, 170))
/// ```
///
/// A single page (an `int`, or a string of digits) gets "p."; anything else
/// gets "pp.". An array of pages is joined with commas.
///
/// -> content
#let gurps-book(
  /// Book title without the leading "GURPS".
  /// -> str | content
  title,
  /// Optional page or pages.
  /// -> int | str | content | array
  ..pages,
) = {
  let pages = take-optional(pages, "gurps-book", "pages")
  let ref = if pages == none {
    none
  } else if type(pages) == array {
    [ pp.~#pages.map(p => [#p]).join([, ])]
  } else if (
    type(pages) == int
      or (type(pages) == str and pages.match(regex("^[0-9]+$")) != none)
  ) {
    [ p.~#pages]
  } else {
    [ pp.~#pages]
  }
  [#strong(emph[GURPS #title])#ref]
}

#let gurps-linked = link(gurps-url, gurps)
#let sjgames-linked = link(sjgames-url, sjgames)

/// The disclaimer the SJ Games online policy asks fan material to carry.
///
/// ```example
/// #sjgames-disclaimer
/// ```
///
/// -> content
#let sjgames-disclaimer = [
  The material presented here is my original creation, intended for use with
  the #gurps-linked system from #sjgames-linked. This material is not official
  and is not endorsed by #sjgames.
]

/// The trademark notice the SJ Games online policy asks fan material to
/// carry. "The art here" is omitted because no SJ Games art is included.
///
/// ```example
/// #sjgames-notice
/// ```
///
/// -> content
#let sjgames-notice = [
  #gurps-linked is a registered trademark of #sjgames-linked, and is
  copyrighted by #sjgames. All rights are reserved by #sjgames. This material
  is used here in accordance with the SJ Games
  #link(online-policy-url)[online policy].
]

/// The notice for a free game aid made without an official license.
///
/// ```example
/// #sjgames-game-aid[Jane Doe]
/// ```
///
/// -> content
#let sjgames-game-aid(
  /// Who made the game aid.
  /// -> str | content
  author,
) = [
  #gurps-linked is a trademark of #sjgames-linked, and its rules and art are
  copyrighted by #sjgames-linked. All rights are reserved by #sjgames. This
  game aid is the original creation of #author and is released for free
  distribution, and not for resale, under the permissions granted in the
  #link(online-policy-url)[#sjgames Online Policy].
]
