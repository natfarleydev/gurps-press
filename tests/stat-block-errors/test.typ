// stat-block() only accepts results of character().
#import "/src/lib.typ": *

#assert-panic(() => stat-block((st: 10)))
#assert(catch(() => stat-block((st: 10))).contains("character("))
#assert-panic(() => stat-block(advantage("A")))
#assert-panic(() => stat-block(character(), show-points: "yes"))
