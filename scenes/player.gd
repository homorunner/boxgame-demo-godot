extends Node2D

var SPEED = 5

var current_position: Vector2i
var target_position: Vector2i
var pending_positions: Array[Vector2i]
var pending_anims: Array[String]
var idle: bool = true
var speed: Vector2

signal after_move

func move_to_immediately(pos: Vector2i, dir: String):
	target_position = pos
	$PlayerNodeAnimation.stop()
	$PlayerNodeAnimation.play("player_" + dir, -1, SPEED)
	speed = (pos * Globals.grid_size - self.position) * SPEED

func move_to(pos: Vector2i, dir: String):
	if idle:
		move_to_immediately(pos, dir)
		idle = false
	else:
		pending_positions.append(pos)
		pending_anims.append(dir)

func reset_animation():
	pending_positions.clear()
	idle = true

func _process(delta: float):
	if not idle:
		if self.position.distance_to(target_position * Globals.grid_size) < (delta * speed).length() + 0.01:
			self.position = target_position * Globals.grid_size
			self.current_position = target_position
			self.after_move.emit()
			if len(pending_positions) >= 1:
				move_to_immediately(pending_positions[0], pending_anims[0])
				pending_positions.pop_front()
				pending_anims.pop_front()
			else:
				idle = true
		else:
			self.position += delta * speed;
		
