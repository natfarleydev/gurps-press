// gurps-book() formats book references like SJ Games does.
#import "/src/lib.typ": gurps-book
#set page(width: 8cm, height: auto, margin: 2mm)

#gurps-book("High Tech") \
#gurps-book("Zombies", 3) \
#gurps-book("Zombies", "3") \
#gurps-book("Warehouse 23", "1, 3–5") \
#gurps-book("Fantasy", (12, 20)) \
#gurps-book([Basic Set], 348) \
#gurps-book("Basic Set") \
#gurps-book[Magic]

#assert-panic(() => gurps-book("A", 1, 2))

// Basic Set pages belong in basic-set(); a content title opts out.
#assert-panic(() => gurps-book("Basic Set", 348))
#assert(catch(() => gurps-book("Basic Set", 348)).contains("basic-set(348)"))
