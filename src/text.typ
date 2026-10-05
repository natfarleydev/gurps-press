// Typographic helpers: the GURPS name, dice notation, book references and
// the Steve Jackson Games online-policy boilerplate.

#import "util.typ": take-optional

#let gurps-url = "http://www.sjgames.com/gurps/"
#let sjgames-url = "http://www.sjgames.com/"
#let online-policy-url = "http://www.sjgames.com/general/online_policy.html"

/// The name #gurps in bold italics. The SJ Games online policy asks for
/// this style. Use it as you use other content.
///
/// ```example
/// #gurps is a generic, universal roleplaying system.
/// ```
///
/// To link it to the GURPS home page, put it in `link`:
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

/// Dice in the notation of the GURPS books. The result does not break
/// across lines.
///
/// ```example
/// #dice(3) \
/// #dice(2, 1) \
/// #dice(4, -1) \
/// #dice(1, 0)
/// ```
///
/// The modifier is optional. A zero modifier shows nothing. A negative
/// modifier has a true minus sign. A content modifier, such as `$m$`,
/// gets a `+`.
///
/// To write basic damage, spread @thrust or @swing into it:
/// `#dice(..thrust(13))`.
///
/// -> content
#let dice(
  /// The number of dice: an integer of 0 or more, or content such as
  /// `$n$`.
  /// -> int | content
  count,
  /// The modifier. It is optional; the default is `0`.
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

/// A reference to a GURPS book in the house style of SJ Games: the title
/// in bold italics, then the pages if you give them.
///
/// ```example
/// #gurps-book("High Tech") \
/// #gurps-book("Zombies", 3) \
/// #gurps-book("Warehouse 23", "1, 3–5") \
/// #gurps-book("Basic Set", (16, 170))
/// ```
///
/// One page (an `int`, or a string of digits) gets "p.". All other pages
/// get "pp.". Commas join the pages in an array.
///
/// -> content
#let gurps-book(
  /// The title of the book, without "GURPS".
  /// -> str | content
  title,
  /// The page or pages. They are optional.
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

/// The disclaimer from the SJ Games online policy. It says that the
/// material is yours and not official.
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

/// The trademark notice from the SJ Games online policy. It does not
/// mention art, because the package includes no SJ Games art.
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

/// The notice from the SJ Games online policy for a free game aid that
/// has no official license.
///
/// ```example
/// #sjgames-game-aid[Jane Doe]
/// ```
///
/// -> content
#let sjgames-game-aid(
  /// The author of the game aid.
  /// -> str | content
  author,
) = [
  #gurps-linked is a trademark of #sjgames-linked, and its rules and art are
  copyrighted by #sjgames-linked. All rights are reserved by #sjgames. This
  game aid is the original creation of #author and is released for free
  distribution, and not for resale, under the permissions granted in the
  #link(online-policy-url)[#sjgames Online Policy].
]
