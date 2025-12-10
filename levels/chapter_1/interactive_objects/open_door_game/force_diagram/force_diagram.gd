extends Node2D


const PIPE_TO_IDLE_SPEED : float = 10
const PIPE_ROTATION_SPEED : float = 2
const MIN_DIAGRAM_ANGLE : float = 0
const MAX_DIAGRAM_ANGLE : float = 180

@onready var diagram : Sprite2D = $Force
@onready var diagram_timer : Timer = $DiagramTimer
@onready var diagram_pipe : Sprite2D = $DiagramPipe

var is_pipe_placed = false


func _process(delta: float) -> void:
	turn_pipe_to_idle(delta)




func calculate_new_diagram_angle() -> void:
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
	if diagram_pipe.rotation_degrees > 90:
		diagram_pipe.rotation_degrees -= PIPE_TO_IDLE_SPEED * delta
		return
	if diagram_pipe.rotation_degrees < 90:
		diagram_pipe.rotation_degrees += PIPE_TO_IDLE_SPEED * delta
		return



func  _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			diagram_pipe.rotation_degrees -= PIPE_ROTATION_SPEED
			return
		if event.button_index == MOUSE_BUTTON_RIGHT:
			diagram_pipe.rotation_degrees += PIPE_ROTATION_SPEED
			return
		return
