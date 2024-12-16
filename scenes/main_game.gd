extends Node

const grid_size = 48
const max_width = 480
const max_height = 480

const LevelScene = preload("res://scenes/level_scene.tscn")

const LEVEL_COUNT = 3
const LEVEL_RECTS: Array[Rect2] = [
	Rect2(1, 0, 8, 8),
	Rect2(0, 8, 9, 8),
	Rect2(9, 12, 14, 5),
]
const CAMERA_RECTS: Array[Rect2] = [
	Rect2(1, 0, 8, 8),
	Rect2(0, 8, 9, 8),
	Rect2(9, 12, 14, 5), # TODO: movable camera in one level
]

var levels: Array[Node] = []
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level_id in range(LEVEL_COUNT):
		var level = LevelScene.instantiate()
		level.init(level_id)
		
		var rect = LEVEL_RECTS[level_id]
		level.position = rect.position * grid_size

		if level_id < LEVEL_COUNT - 1:
			var goto_next_level = func():
				levels[level_id].deactivate()
				levels[level_id + 1].activate()
				target_position = Vector2(80, 80) - LEVEL_RECTS[level_id + 1].position * grid_size
			level.win.connect(goto_next_level)
		# TODO: last_level.win may connect to a YOU-WIN stage.

		levels.append(level)
		add_child(level)
		
		level.deactivate()
	
	levels[0].activate()
	target_position = Vector2(80, 80) - LEVEL_RECTS[0].position * grid_size
	self.position = target_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = lerp(self.position, target_position, 2 * delta)
