@tool
extends Node

const LEVEL_RECTS: Array[Vector2i] = [
	Vector2i(7, 8),  # Level 1.0
	Vector2i(8, 6),  # Level 1.1
	Vector2i(8, 7),  # Level 1.2
	Vector2i(10, 10),# Level 1.4
	Vector2i(10, 8), # Level 1.6
	Vector2i(7, 8),  # Level 2.0
	Vector2i(7, 8),  # Level 2.1
	Vector2i(9, 10),  # Level 2.2
]

const LEVEL_MAP = [
	"""
ooooooo
oS....o
o.....o
ooo...o
o..111o
o.....o
o...o.o
oooooEo
""",  # Level 1.0: 教学1，体验一下推箱子。
	"""
 oSooooo
 o....oo
oo.....o
o..112.o
o...122o
oooooEoo
""",  # Level 1.1: 教学2，体验一下两个箱子，纯线性关卡。
	"""
oSoooooo
o......o
o..22..o
o.3322oo
o..34.o
o...44o
oooooEo
""",  # Level 1.2: 教学3，体验一下三个箱子，纯线性关卡。
	"""
__oooooooo
__ooo....o
oSo...33.o
o..222.33o
o..oo44..o
o.....4..o
o.....4..o
o.....111o
o.......1o
ooooooooEo
""", # Level 1.4: 教学4，略微反直觉。如果把222往右推就会卡关，可以在这里引出“按R重试本关”的教学。
	"""
____oooooo
oSooo....o
o...221..o
o..22.1..o
o...3.144o
o...33..4o
o...3...4o
ooooooooEo
""", # Level 1.6: 综合关，难度指数2，有趣程度3，需要把4号方块先进再出，求解过程比较线性。
	"""
oooSooo
o.....o
o.1111o
o2....o
o2....o
o2....o
>2....<
oooEooo
""", # Level 2.0: 引入消除
	"""
oooSooo
>222..<
>.2...<
>.....<
>..11.<
>...11<
>...33<
ooooEoo
""", # Level 2.1: 基于消除的简单关卡
	"""
ooooooSoo
>.......<
>.1.....<
>.11....<
>.1..<ooo
>..33<ooo
>.33....<
>..22244<
>...2.44<
oooooooEo
""", # Level 2.2
]
