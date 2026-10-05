// basic-set() writes Basic Set pages as SJ Games does: "p. B348".
#import "/src/lib.typ": basic-set
#set page(width: 8cm, height: auto, margin: 2mm)

#basic-set(348) \
#basic-set("348") \
#basic-set((16, 170)) \
#basic-set("16–17") \
#basic-set[16–17]

#assert-panic(() => basic-set(1.5))
#assert-panic(() => basic-set(none))
#assert(catch(() => basic-set(1.5)).contains("int, str, content or array"))
