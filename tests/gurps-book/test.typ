// gurps-book() formats book references like SJ Games does.
#import "/src/lib.typ": gurps-book
#set page(width: 8cm, height: auto, margin: 2mm)

#gurps-book("High Tech") \
#gurps-book("Zombies", 3) \
#gurps-book("Zombies", "3") \
#gurps-book("Warehouse 23", "1, 3–5") \
#gurps-book("Basic Set", (16, 170)) \
#gurps-book[Magic]

#assert-panic(() => gurps-book("A", 1, 2))
