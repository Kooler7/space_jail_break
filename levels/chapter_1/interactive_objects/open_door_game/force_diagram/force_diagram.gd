extends Node2D

signal pipe_placed
signal pipe_lost_place

const PIPE_TO_IDLE_SPEED : float = 10
const PIPE_ROTATION_SPEED : float = 2
const MIN_DIAGRAM_ANGLE : float = 0
const MAX_DIAGRAM_ANGLE : float = 180

@onready var _diagram : Sprite2D = $Force
@onready var _diagram_timer : Timer = $DiagramTimer
@onready var _diagram_pipe : Sprite2D = $DiagramPipe

var _is_pipe_placed = false
var _delta_angle : float
var _is_diagram_active = false



func _process(delta: float) -> void:
	if _is_diagram_active:
		_delta_angle = abs(_diagram_pipe.rotation_degrees - _diagram.rotation_degrees)
		if _delta_angle < 10:
			_is_pipe_placed = true
			emit_signal("pipe_placed")
		elif _delta_angle > 10:
			_is_pipe_placed = false
			emit_signal("pipe_lost_place")
		_turn_pipe_to_idle(delta)


func set_diagram_activity(value: bool) -> void:
	if value:
		_calculate_timeout()
	if not value:
		_diagram_timer.stop()
		_is_pipe_placed = value
	_is_diagram_active = value

func get_pipe_place() -> bool:
	return _is_pipe_placed

func _calculate_timeout() -> void:
	_diagram_timer.wait_time = randi_range(1, 3)
	_diagram_timer.start()
	await _diagram_timer.timeout
	_calculate_new_diagram_angle()


func _calculate_new_diagram_angle() -> void:
	if _is_diagram_active:
		var take_angle = randi_range(0, 1)
		if take_angle == 1:
			var angle = randi_range(MIN_DIAGRAM_ANGLE, MAX_DIAGRAM_ANGLE)
			_rotate_diagram(angle)
		_calculate_timeout()


func _rotate_diagram(new_angle : float) -> void:
	var duration : float = abs(new_angle - _diagram.rotation_degrees) * 0.01
	var rotate_tween = create_tween()
	rotate_tween.tween_property(_diagram, "rotation_degrees", new_angle, duration)
	rotate_tween.play()


func _turn_pipe_to_idle(delta : float) -> void:
	if _is_diagram_active:
		if _diagram_pipe.rotation_degrees > 90:
			_diagram_pipe.rotation_degrees -= PIPE_TO_IDLE_SPEED * delta
			return
		if _diagram_pipe.rotation_degrees < 90:
			_diagram_pipe.rotation_degrees += PIPE_TO_IDLE_SPEED * delta
			return



func  _input(event: InputEvent) -> void:
	if _is_diagram_active:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				_diagram_pipe.rotation_degrees -= PIPE_ROTATION_SPEED
				return
			if event.button_index == MOUSE_BUTTON_RIGHT:
				_diagram_pipe.rotation_degrees += PIPE_ROTATION_SPEED
				return
			return
