extends Node2D

var SPEED = 5

var target_position: Vector2
var pending_positions: Array[Vector2]
var pending_anims: Array[String]
var idle: bool = true
var speed: Vector2

func set_color(color: Color):
	$ColorRect.color = color

func move_to_immediately(pos: Vector2, dir: String):
	target_position = pos
	speed = (pos - self.position) * SPEED

func move_to(pos: Vector2, dir: String):
	if idle:
		move_to_immediately(pos, dir)
		idle = false
	else:
		pending_positions.append(pos)
		pending_anims.append(dir)

func _process(delta: float):
	if not idle:
		if self.position.distance_to(target_position) < (delta * speed).length() + 0.01:
			self.position = target_position
			if len(pending_positions) >= 1:
				move_to_immediately(pending_positions[0], pending_anims[0])
				pending_positions.pop_front()
				pending_anims.pop_front()
			else:
				idle = true
		else:
			self.position += delta * speed;
		
