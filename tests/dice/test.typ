// dice() renders GURPS dice notation. Compared against ref.typ.
#import "/src/lib.typ": dice
#set page(width: 6cm, height: auto, margin: 2mm)

#dice(3) \
#dice(2, 1) \
#dice(4, -1) \
#dice(1, 0) \
#dice(7, 11) \
#dice($n$, $m$) \
#dice(0, 3)
