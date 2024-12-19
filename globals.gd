extends Node

const grid_size = 48.0

const levels = [
	"""
oooooooo
oS..1.oo
o..11.oo
o.21...o
oo2....o
o22...oo
o.oooooo
o.oooooo
oEoooooo
""",  # Level 0
	"""
ooSoooooo
o..3....o
o..3....o
o..35555o
o..3511.o
o.44441.o
o2222.1..E
o....oooo
ooooooooo
""",  # Level 1
	"""
ooo
S.o
o.o
oEo
""", # Level 2
	"""
   oooooo
oSoo....o
o....33.o
o.222.33o
o...44..o
o....4..o
o....4..o
o....111o
o......1o
oooooooEo
""", # Level 3
   """
ooooooSo
o......o
o......o
o...33.o
o.1113.o
o...13.o
o..2222o
o.44...o
o..44..o
ooooooEo
""", # Level 4
]
