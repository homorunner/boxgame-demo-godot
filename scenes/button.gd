extends TouchScreenButton

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if self.is_pressed():
		self.modulate.a = 0.75
	else:
		self.modulate.a = 0.5
