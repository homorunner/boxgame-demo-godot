@tool
extends Node2D

# constants
enum {NODE_UNDEFINED, NODE_WALL, NODE_GRASS, NODE_BOX}

const BasicSquare = preload("res://scenes/basic_square.tscn")

# signals
signal win

# class definitions
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

class Box:
	extends GameNode
	
	var block_id: int
	var color_id: int
	var node_id: int
	var polyomino_id: int
	
	func _init(_pos_x, _pos_y, _block_id, _color_id):
		super(_pos_x, _pos_y)
		type = NODE_BOX
		block_id = _block_id
		color_id = _color_id
		polyomino_id = -1

class BoxNode:
	var box: Box
	
	# this is the instance of dynamic created BasicSquare(Node2D)
	# now i don't find a way to include definition of class BasicSquare in this script.
	var basic_square: Node
	
	func _init(_box: Box):
		var _basic_square = BasicSquare.instantiate()
		_basic_square.position = _box.pos * Globals.grid_size
		_basic_square.set_color(Globals.Colors[_box.color_id])
		
		self.box = _box
		self.basic_square = _basic_square
	
	func set_color(color_id: int):
		basic_square.set_color(Globals.Colors[color_id])
	
	func move_to(pos: Vector2i, dir: String):
		self.basic_square.move_to(pos * Globals.grid_size, dir)

class Polynomino:
	var poly_id: int
	var box_ids: Array[int]

var rows = 0
var columns = 0
var player_pos: Vector2i
var destination_pos: Vector2i
var gamenodes: Array[GameNode] = []
var polynominos: Array[Polynomino] = []
var wall_map: Array[Array] = []
var grass_map: Array[Array] = []
var box_map: Array[Array] = []

# Dynamic nodes
var box_nodes: Array[BoxNode] = []

func get_box(x, y) -> Box:
	if x < 0 or x >= columns or y < 0 or y >= rows:
		return null
	var id = box_map[x][y]
	if id < 0:
		return null
	return gamenodes[id]

func get_wall(x, y) -> Wall:
	if x < 0 or x >= columns or y < 0 or y >= rows:
		return null
	var id = wall_map[x][y]
	if id < 0:
		return null
	return gamenodes[id]

func init_box_map():
	box_map.clear()
	for i in range(columns):
		var arr = []
		arr.resize(rows + 1)
		arr.fill(-1)
		box_map.append(arr)
	
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_BOX:
			var box: Box = gamenodes[i]
			box_map[box.pos.x][box.pos.y] = i

func init_wall_map():
	wall_map.clear()
	for i in range(columns):
		var arr = []
		arr.resize(rows)
		arr.fill(-1)
		wall_map.append(arr)
	
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_WALL:
			wall_map[gamenodes[i].pos.x][gamenodes[i].pos.y] = i

func init_grass_map():
	grass_map.clear()
	for i in range(columns):
		var arr = []
		arr.resize(rows)
		arr.fill(-1)
		grass_map.append(arr)
	
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_GRASS:
			grass_map[gamenodes[i].pos.x][gamenodes[i].pos.y] = i

func init_polys():
	polynominos.clear()
	var parent_id = []
	var _p = func (x, f):
		if parent_id[x] == x:
			return x
		else:
			parent_id[x] = f.call(parent_id[x], f)
			return parent_id[x]
	var get_parent = func (x):
		return _p.call(x, _p)
	for i in range(len(gamenodes)):
		parent_id.append(i)
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_BOX:
			var box: Box = gamenodes[i]
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if abs(dx) + abs(dy) != 1:
						continue
					var sidebox = get_box(box.pos.x + dx, box.pos.y + dy)
					if sidebox == null or sidebox.color_id != box.color_id:
						continue
					parent_id[get_parent.call(box.block_id)] = get_parent.call(sidebox.block_id) 
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_BOX:
			var box: Box = gamenodes[i]
			if parent_id[get_parent.call(box.block_id)] == box.block_id:
				var poly = Polynomino.new()
				poly.poly_id = len(polynominos)
				for j in range(len(gamenodes)):
					if gamenodes[j].type == NODE_BOX:
						var boxx: Box = gamenodes[j]
						if get_parent.call(boxx.block_id) == box.block_id:
							poly.box_ids.append(boxx.block_id)
							boxx.polyomino_id = poly.poly_id
				polynominos.append(poly)
				print('initializing polys: id = ', poly.poly_id, ', box_ids = ', poly.box_ids)

func test_collision_and_push(dx: int, dy: int, dir: String) -> bool:
	var wall = get_wall(player_pos.x + dx, player_pos.y + dy)
	if wall != null:
		return false
	
	var box = get_box(player_pos.x + dx, player_pos.y + dy)
	var can_move = true
	if box != null:
		# TODO: maybe we should consider if this is allowed to push two polys in one move.
		# currently it is not allowed.

		var poly = polynominos[box.polyomino_id]
		for i in poly.box_ids:
			var boxx: Box = gamenodes[i]
			var sidebox = get_box(boxx.pos.x + dx, boxx.pos.y + dy)
			if sidebox != null:
				if sidebox.polyomino_id == box.polyomino_id:
					continue
				can_move = false
				break
			var sidewall = get_wall(boxx.pos.x + dx, boxx.pos.y + dy)
			if sidewall != null:
				can_move = false
				break
		
		if can_move:
			for i in poly.box_ids:
				var boxx: Box = gamenodes[i]
				boxx.pos.x += dx
				boxx.pos.y += dy
				box_nodes[boxx.node_id].move_to(boxx.pos, dir)
				
			# after a poly move, we reinit the box map
			init_box_map()

	return can_move
	
func on_move_up():
	if test_collision_and_push(0, -1, 'up'):
		player_pos.y -= 1
		launch_movement('up')
	else:
		launch_movement('up')

func on_move_down():
	if test_collision_and_push(0, 1, 'down'):
		player_pos.y += 1
		launch_movement('down')
	else:
		launch_movement('down')

func on_move_left():
	if test_collision_and_push(-1, 0, 'left'):
		player_pos.x -= 1
		launch_movement('left')
	else:
		launch_movement('left')

func on_move_right():
	if test_collision_and_push(1, 0, 'right'):
		player_pos.x += 1
		launch_movement('right')
	else:
		launch_movement('right')

func launch_movement(dir: String):
	$Player.move_to(player_pos, dir)
	
func win_detect():
	if $Player.current_position == destination_pos:
		print('level ', current_level, ' win.')
		win.emit()

func init_signals():
	$Player.after_move.connect(win_detect)

var current_level = 0

func init(level:int):
	current_level = level
	var game_map_string = Levels.LEVEL_MAP[level]
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
				gamenodes.append(GameNode.new(j, i))
			elif line[j] == '.':
				gamenodes.append(Grass.new(j, i))
			elif line[j] == 'o':
				gamenodes.append(Wall.new(j, i))
			elif line[j] >= '1' and line[j] <= '9':
				gamenodes.append(Grass.new(j, i)) # currently, block must start on a grass node.
				gamenodes.append(Box.new(j, i, len(gamenodes), line[j].to_int()))
			elif line[j] == 'S':
				gamenodes.append(Grass.new(j, i)) # currently, player starting point must be a grass node.
				player_pos.x = j
				player_pos.y = i
				$Player.position = player_pos * Globals.grid_size
			elif line[j] == 'E':
				gamenodes.append(Grass.new(j, i)) # currently, destination point must be a grass node.
				destination_pos.x = j
				destination_pos.y = i
			else:
				gamenodes.append(GameNode.new(j, i))
	print('parsing game map: gamenodes.size() = ', len(gamenodes))

	# Initialize maps
	init_wall_map()
	init_grass_map()
	init_box_map()
	
	# Initialize polynominos
	init_polys()
	
	init_signals()
	
	# Set grass terrain list (static)
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_GRASS:
			$Grass.add_node(gamenodes[i].pos)
	$Grass.flush_nodes()
	
	# Set wall cells (static)
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_WALL:
			var pos = gamenodes[i].pos
			var shadow = []
			shadow.append(pos.x < columns - 1 and grass_map[pos.x+1][pos.y] > 0) # right
			shadow.append(pos.x > 0 and grass_map[pos.x-1][pos.y] > 0)           # left
			shadow.append(pos.y > 0 and grass_map[pos.x][pos.y-1] > 0)           # up
			shadow.append(pos.y < rows - 1 and grass_map[pos.x][pos.y+1] > 0)    # down
			shadow.append(pos.x < columns - 1 and pos.y < rows - 1 and grass_map[pos.x+1][pos.y+1] > 0) # right-down
			$Wall.add_node(pos, shadow)
	$Wall.flush_nodes()
	
	# Basic square
	for i in range(len(gamenodes)):
		if gamenodes[i].type == NODE_BOX:
			var box_node = BoxNode.new(gamenodes[i])
			add_child(box_node.basic_square)
			box_node.box.node_id = len(box_nodes)
			box_nodes.append(box_node)

func activate():
	self.set_process_input(true)
	$Player.show()
	
func deactivate():
	self.set_process_input(false)
	$Player.hide()

func reinit():
	gamenodes.clear()
	
	$Player.reset_animation()
	
	for node in box_nodes:
		remove_child(node.basic_square)
	box_nodes.clear()
	
	init(current_level)

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
		elif event.is_action("restart"):
			reinit()
		elif event.is_action("skip_level"):
			win.emit()

func _process(delta: float) -> void:
	pass
