extends CanvasLayer

@export var point_interval_seconds: float = 1
@export var points_on_screen: int = 120
@export var max_fps: int = 60
@export var enable_f12_shortcut: bool = true

@onready var _line: Line2D = $Line
@onready var _timer: Timer = $Timer
@onready var _label: Label = $Label


@onready var _window_size: Vector2 = _line.get_viewport_rect().size
@onready var _line_width_margin: float = _line.width / 2.0
var _x_delta: float


func _ready() -> void:
	visible = false

	_x_delta = _window_size.x / points_on_screen

	points_on_screen += 1

	for i in points_on_screen:
		_line.add_point(Vector2(_x_delta * i, _window_size.y - _line_width_margin))

	_timer.start(point_interval_seconds)
	_timer.connect("timeout", self._on_timer_timeout)


func _input(event: InputEvent) -> void:
	if not enable_f12_shortcut:
		return
	if not event is InputEventKey or not event.keycode == KEY_F12 or not event.is_pressed():
		return

	visible = !visible


func add_point() -> void:
	for i in range(1, points_on_screen):
		_line.points[i - 1] = _line.points[i] - Vector2(_x_delta, 0)

	var fps: int = Engine.get_frames_per_second()

	_line.points[-1] = Vector2(
		_window_size.x,
		remap(fps, 0, max_fps, _window_size.y - _line_width_margin, _line_width_margin)
	)

	_label.text = "FPS " + str(fps)


func _on_timer_timeout() -> void:
	add_point()
