extends Node2D

signal pipe_placed
signal pipe_lost_place

const PIPE_TO_IDLE_SPEED : float = 10
const PIPE_ROTATION_SPEED : float = 2
const MIN_DIAGRAM_ANGLE : float = 0
const MAX_DIAGRAM_ANGLE : float = 180

@onready var diagram : Sprite2D = $Force
@onready var diagram_timer : Timer = $DiagramTimer
@onready var diagram_pipe : Sprite2D = $DiagramPipe

var is_pipe_placed = false
var delta_angle : float
var is_started = false





func _process(delta: float) -> void:
	if is_started:
		delta_angle = abs(diagram_pipe.rotation_degrees - diagram.rotation_degrees)
		if delta_angle < 10:
			if is_pipe_placed == false:
				is_pipe_placed = true
				emit_signal("pipe_placed")
		elif delta_angle > 10:
			if is_pipe_placed == true:
				is_pipe_placed = false
				emit_signal("pipe_lost_place")
		turn_pipe_to_idle(delta)




func calculate_new_diagram_angle() -> void:
	if is_started:
		diagram_timer.wait_time = randi_range(1, 3)
		diagram_timer.start()
		await  diagram_timer.timeout
		var take_angle = randi_range(0, 1)
		if take_angle == 1:
			var angle = randi_range(MIN_DIAGRAM_ANGLE, MAX_DIAGRAM_ANGLE)
			rotate_diagram(angle)
			calculate_new_diagram_angle()
		elif take_angle == 0:
			calculate_new_diagram_angle()


func rotate_diagram(new_angle : float) -> void:
	var duration : float = abs(new_angle - diagram.rotation_degrees) * 0.01
	var rotate_tween = create_tween()
	rotate_tween.tween_property(diagram, "rotation_degrees", new_angle, duration)
	rotate_tween.play()


func turn_pipe_to_idle(delta : float) -> void:
	if is_started:
		if diagram_pipe.rotation_degrees > 90:
			diagram_pipe.rotation_degrees -= PIPE_TO_IDLE_SPEED * delta
			return
		if diagram_pipe.rotation_degrees < 90:
			diagram_pipe.rotation_degrees += PIPE_TO_IDLE_SPEED * delta
			return



func  _input(event: InputEvent) -> void:
	if is_started:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				diagram_pipe.rotation_degrees -= PIPE_ROTATION_SPEED
				return
			if event.button_index == MOUSE_BUTTON_RIGHT:
				diagram_pipe.rotation_degrees += PIPE_ROTATION_SPEED
				return
			return
