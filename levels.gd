@tool
extends Node

const LEVEL_RECTS: Array[Vector2i] = [
	Vector2i(7, 8),  # Level 1.0
	Vector2i(7, 6),  # Level 1.1
	Vector2i(8, 7),  # Level 1.2
	Vector2i(9, 8),  # Level 1.3
	Vector2i(3, 3),
	Vector2i(10, 10),# Level 1.4
	Vector2i(12, 9), # Level 1.5
	Vector2i(10, 8), # Level 1.6
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
""",  # Level 1.0: 教学，体验一下推箱子。
	"""
o.ooooo
oSo...o
o..111o
o...2.o
o...22o
ooooEoo
""",  # Level 1.1: 教学1，体验一下多个箱子，纯线性关卡。
	"""
oSoooooo
o......o
o..22..o
o.3322oo
o..34.o
o...44o
oooooEo
""",  # Level 1.2: 教学2，体验一下多个箱子，纯线性关卡。
	"""
ooSoooooo
o..o....o
o..o....o
o...555.o
o...5.1.o
o..4441.o
o.222.1..E
o....oooo
ooooooooo
""",  # Level 1.3: 教学3，如果把111往右推就会卡关，可以在这里引出“按R重试本关”的教学。
	"""
ooo
S.o
oEo
""", # 转场，测试镜头移动用
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
oSoooooooooo
o...oo.55..o
o.111...5..o
o..144..5..o
o.6664422..o
o.6...223..o
o.......33.o
o.......3..o
ooooooooooEo
""", # Level 1.5: 综合关，难度指数1，有趣程度3，有点反直觉但求解过程线性。
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
]
