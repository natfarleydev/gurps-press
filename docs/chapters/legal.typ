#import "/src/lib.typ": *
#import "../style.typ": answers, examples
#show: examples

#let policy = "https://www.sjgames.com/general/online_policy.html"

#answers(
  [Which notices must my material have? (@legal-notices)],
  [What if my material is a free game aid? (@legal-game-aid)],
  [How do I write "GURPS"? (@legal-trademarks)],
  [Can my book look like a GURPS book? (@legal-look)],
  [Where does the text of the notices come from? (@legal-sources)],
)

`gurps-ink` gives you text. It does not give legal advice. Read the
#link(policy)[#sjgames online policy] before you publish. The policy is
for free material. To sell material, read its section VII, "Licensed
Use".

== Add the disclaimer and the notice <legal-notices>

Section IV of the online policy, "Notices and Disclaimers", asks for two
texts on material that is not official:

- A _disclaimer_: the material is not official and #sjgames does not
  endorse it. Use `sjgames-disclaimer`.
- A _notice_: #gurps is a trademark of #sjgames. Use `sjgames-notice`.

Both texts have links to the #sjgames pages, as the policy asks. Put
them on the title page or on the last page. You can make them small.

```typ
#import "@preview/gurps-ink:0.1.0": *

#set text(size: 7pt)
#sjgames-disclaimer

#sjgames-notice
```

== Add a game aid notice <legal-game-aid>

`sjgames-game-aid` is a notice for a free game aid, such as a character
sheet or a tool. Give it the name of the author. The online policy does
not give this text. Many free #gurps game aids use it, for example the
GURPS system for Foundry VTT.

```typ
#import "@preview/gurps-ink:0.1.0": *

#set text(size: 7pt)
#sjgames-game-aid[Jane Doe]
```

== Write GURPS and other trademarks <legal-trademarks>

The online policy asks you to show each trademark in bold, italic or
colour each time you use it. `gurps` writes #gurps in bold italics.
`sjgames` writes #sjgames. For other trademarks, use `strong` and
`emph`.

```typ
#import "@preview/gurps-ink:0.1.0": *

This is a one-shot for #gurps.
#sjgames publishes
#strong(emph[Munchkin]) too.
```

Do not put `#gurps` in italic text. In italic text, `emph` makes it
upright.

== Use your own look <legal-look>

Section II of the online policy says that if your material looks like a
#sjgames product, it is "over the line". For example, do not copy the
covers of #gurps books.

`gurps-ink` does not copy the look of #gurps books. It sets no fonts,
colours or page layout. It follows the typographic rules of #sjgames:
how to write dice, book titles, page references and stat blocks. Choose
your own fonts, colours and layout.

== Where the text comes from <legal-sources>

#table(
  columns: 2,
  [*Function*], [*Source*],
  [`sjgames-disclaimer`],
  [The example disclaimer in section IV of the
    #link(policy)[online policy].],

  [`sjgames-notice`],
  [The example notice in section IV of the #link(policy)[online policy],
    without the sentence about art.],

  [`sjgames-game-aid`],
  [Not from the policy. The notice that many free #gurps game aids use.],

  [`gurps`, `sjgames`],
  [The trademark rules in the #link(policy)[online policy].],
)
