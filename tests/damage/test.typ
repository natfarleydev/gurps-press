// thrust() and swing() follow the Basic Set damage table (B16).
#import "/src/lib.typ": swing, thrust

#assert.eq(thrust(1), (1, -6))
#assert.eq(swing(1), (1, -5))
#assert.eq(thrust(10), (1, -2))
#assert.eq(swing(10), (1, 0))
#assert.eq(thrust(13), (1, 0))
#assert.eq(swing(13), (2, -1))
#assert.eq(thrust(20), (2, -1))
#assert.eq(swing(20), (3, 2))
#assert.eq(swing(28), (5, 1))
#assert.eq(thrust(40), (4, 1))
#assert.eq(swing(40), (7, -1))
// Between rows above 40 the lower row applies.
#assert.eq(thrust(44), (4, 1))
#assert.eq(thrust(45), (5, 0))
#assert.eq(swing(47), (7, 1))
#assert.eq(thrust(100), (11, 0))
#assert.eq(swing(100), (13, 0))

#assert-panic(() => thrust(0))
#assert-panic(() => swing(101))
#assert-panic(() => thrust(12.5))
#assert(catch(() => thrust(101)).contains("thr"))
