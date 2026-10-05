// dice() rejects nonsense with a helpful message.
#import "/src/lib.typ": dice

#assert-panic(() => dice(-1))
#assert-panic(() => dice(2.5))
#assert-panic(() => dice("3"))
#assert-panic(() => dice(3, 1.5))
#assert-panic(() => dice(3, 1, 2))
#assert-panic(() => dice(3, mod: 1))
#assert(catch(() => dice(-1)).contains("non-negative"))
#assert(catch(() => dice(3, 1, 2)).contains("at most one"))

// A dice expression never breaks across lines.
#assert.eq(dice(3).func(), box)
