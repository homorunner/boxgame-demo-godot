extends Node2D

enum {NODE_UNDEFINED, NODE_WALL, NODE_GRASS}

class GameNode:
	var pos: Vector2i
	var type = NODE_UNDEFINED
	
	func _init(_pos_x: int, _pos_y: int):
		pos = Vector2i(_pos_x, _pos_y)

class Wall:
	extends GameNode
	
	func _init(_pos_x, _pos_y):
		super(_pos_x, _pos_y)
		type = NODE_WALL

class Grass:
	extends GameNode
	
	func _init(_pos_x, _pos_y):
		super(_pos_x, _pos_y)
		type = NODE_GRASS

var rows = 0
var columns = 0
var player_pos: Vector2i
var blocks: Array[GameNode] = [] # array of blocks in this game

var grid_size = 48

func on_move_up():
	player_pos.y -= 1
	launch_movement('up')

func on_move_down():
	player_pos.y += 1
	launch_movement('down')

func on_move_left():
	player_pos.x -= 1
	launch_movement('left')

func on_move_right():
	player_pos.x += 1
	launch_movement('right')

func launch_movement(dir: String):
	$Player.move_to(player_pos * grid_size, dir)

func _ready() -> void:
	var game_map_string = """
oooooooooo
oS.......o
o........o
o......ooo
o......ooo
oo...ooooo
oooooooooo
"""
	var _lines = game_map_string.split('\n')
	var game_map_lines = []
	rows = 0
	columns = 0
	player_pos = Vector2i(0, 0)
	for i in range(len(_lines)):
		var line = _lines[i]
		if len(line) > 0:
			game_map_lines.append(line)
			rows += 1
			columns = max(columns, len(line))
	print('parsing game map: rows = ', rows, ', columns = ', columns)
	
	for i in range(rows):
		var line = game_map_lines[i]
		for j in range(columns):
			if j >= len(line):
				blocks.append(GameNode.new(j, i))
			elif line[j] == '.':
				blocks.append(Grass.new(j, i))
			elif line[j] == 'o':
				blocks.append(Wall.new(j, i))
			elif line[j] == 'S':
				blocks.append(Grass.new(j, i)) # currently, starting point must be a grass node.
				player_pos.x = j
				player_pos.y = i
				$Player.position = player_pos * grid_size
			else:
				blocks.append(GameNode.new(j, i))
	print('parsing game map: blocks.size() = ', len(blocks))
	
	# Set grass terrain list (static)
	for i in range(len(blocks)):
		if blocks[i].type == NODE_GRASS:
			$Grass.add_node(blocks[i].pos)
	$Grass.flush_nodes()
	
	# Set wall cells (static)
	for i in range(len(blocks)):
		if blocks[i].type == NODE_WALL:
			$Wall.add_node(blocks[i].pos)
	$Wall.flush_nodes()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action("up"):
			on_move_up()
		elif event.is_action("down"):
			on_move_down()
		elif event.is_action("left"):
			on_move_left()
		elif event.is_action("right"):
			on_move_right()

func _process(delta: float) -> void:
	pass
