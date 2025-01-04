@tool
extends Node

@onready var you_win: Node2D = $"../YouWin"

const max_width = 480
const max_height = 480

const LevelScene = preload("res://scenes/level_scene.tscn")

var levels: Array[Node] = []

# Main scene camera.
const camera_up_min = 80.0
const camera_left_min = 80.0
const camera_speed = 2.33
var camera_bases: Array[Vector2] = []
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_pos: Array[Vector2i] = []
	var end_pos: Array[Vector2i] = []
	var level_count = len(Levels.LEVEL_MAP)
	for level_id in range(level_count):
		var game_map_string = Levels.LEVEL_MAP[level_id]
		var _lines = game_map_string.split('\n')
		var row = 0
		var has_start = false
		var has_end = false
		for i in range(len(_lines)):
			var line = _lines[i]
			if len(line) > 0:
				row += 1
				for column in range(len(line)):
					if line[column] == 'S':
						start_pos.append(Vector2i(column, row))
						print('level ', level_id, ' start_pos ', start_pos.back())
						has_start = true
					elif line[column] == 'E':
						end_pos.append(Vector2i(column, row))
						print('level ', level_id, ' end_pos ', end_pos.back())
						has_end = true
		if not has_start or not has_end:
			print('Error: Level ', level_id, ' does not has S or E!')
			return

	var last_end_position = Vector2i(0, 0)

	for level_id in range(level_count):
		var level = LevelScene.instantiate()
		level.init(level_id)
		
		var rect = Levels.LEVEL_RECTS[level_id]
		level.position = (last_end_position - start_pos[level_id]) * Globals.grid_size
		last_end_position = last_end_position - start_pos[level_id] + end_pos[level_id]
		
		# Calculate camera position of each level.
		var camera_base_x = max(camera_left_min, (Globals.window_width - Levels.LEVEL_RECTS[level_id].x * Globals.grid_size) * 0.5)
		var camera_base_y = max(camera_up_min, (Globals.window_height - Levels.LEVEL_RECTS[level_id].y * Globals.grid_size) * 0.5)
		camera_bases.append(Vector2(camera_base_x, camera_base_y) - level.position)
		
		# Goto next level or show you_win.
		if level_id < level_count - 1:
			var goto_next_level = func(from_dir_x: int, from_dir_y: int):
				levels[level_id].deactivate()
				levels[level_id + 1].activate()
				levels[level_id + 1].back_dir_x = -from_dir_x
				levels[level_id + 1].back_dir_y = -from_dir_y
				target_position = camera_bases[level_id + 1]
			level.win.connect(goto_next_level)
		else:
			var show_you_win = func():
				you_win.show()
			level.win.connect(show_you_win)
		
		# Go back to previous level.
		if level_id > 0:
			var goto_previous_level = func(from_dir_x: int, from_dir_y: int):
				levels[level_id].deactivate()
				levels[level_id - 1].activate()
				levels[level_id - 1].on_move(from_dir_x, from_dir_y)
				target_position = camera_bases[level_id - 1]
			level.goback.connect(goto_previous_level)
		
		levels.append(level)
		add_child(level)
		
		level.deactivate()
	
	levels[0].activate()
	target_position = camera_bases[0]
	self.position = target_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = lerp(self.position, target_position, camera_speed * delta)
