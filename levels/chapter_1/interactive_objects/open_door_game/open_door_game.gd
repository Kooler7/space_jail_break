extends Node2D

signal pipe_angle_reached

@onready var pipe : AnimatedSprite2D = $Pipe
@onready var door : Sprite2D = $Door
@onready var death_timer : Timer = $DeathTimer
@onready var diagram : Sprite2D = $Force
@onready var diagram_timer : Timer = $DiagramTimer
@onready var tip_1 :Label = $Tip1
@onready var diagram_pipe : Sprite2D = $DiagramPipe
@onready var frame_counter = $Label2
@onready var shake_door : AnimationPlayer = $AnimationPlayer

const PIPE_TO_IDLE_SPEED : float = 10
const PIPE_ROTATION_SPEED : float = 2
const MIN_DIAGRAM_ANGLE : float = -90
const MAX_DIAGRAM_ANGLE : float = 90

enum GameStages {
	STAGE_1,
	STAGE_2,
	FINISHED,
	LOOSE
}
var current_game_stage : GameStages = GameStages.STAGE_1
@export var new_stage : GameStages = GameStages.STAGE_1

var is_pipe_in_position : bool = false




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_game_stage(new_stage)
	turn_pipe_to_idle(delta)
	scene_pipe_animation()
	frame_counter.text = str(diagram_pipe.rotation_degrees)
	print(diagram.rotation_degrees)






func update_game_stage(new_stage) -> void:
	if current_game_stage != new_stage:
		match new_stage:
			GameStages.STAGE_1:
				tip_1.hide()
				diagram.hide()
			GameStages.STAGE_2:
				tip_1.show()
				diagram.show()
				current_game_stage = GameStages.STAGE_2
				diagram.rotation_degrees = randi_range(MIN_DIAGRAM_ANGLE, MAX_DIAGRAM_ANGLE)
				calculate_new_diagram_angle()
			GameStages.FINISHED:
				pass
			GameStages.LOOSE:
				pass

func scene_pipe_animation() -> void:
	if current_game_stage == GameStages.STAGE_2:
		if abs(abs(diagram_pipe.rotation_degrees) - abs(diagram.rotation_degrees)) < 10:
			if pipe.frame_progress < 1:
				pipe.play()
			#await pipe.animation_finished
			shake_door.play("shake_door")
		elif abs(abs(diagram_pipe.rotation_degrees) - abs(diagram.rotation_degrees)) > 10:
			if pipe.frame!= 0:
				pipe.play_backwards()
				shake_door.stop()


func calculate_new_diagram_angle() -> void:
	if current_game_stage == GameStages.STAGE_2:
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
	print(duration)
	var rotate_tween = create_tween()
	rotate_tween.tween_property(diagram, "rotation_degrees", new_angle, duration)
	rotate_tween.play()

func turn_pipe_to_idle(delta : float) -> void:
	if current_game_stage == GameStages.STAGE_2:
		if diagram_pipe.rotation_degrees > 0:
			diagram_pipe.rotation_degrees -= PIPE_TO_IDLE_SPEED * delta
			return
		if diagram_pipe.rotation_degrees < 0:
			diagram_pipe.rotation_degrees += PIPE_TO_IDLE_SPEED * delta
			return
	return


func  _input(event: InputEvent) -> void:
	if current_game_stage == GameStages.STAGE_2:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				diagram_pipe.rotation_degrees -= PIPE_ROTATION_SPEED
				return
			if event.button_index == MOUSE_BUTTON_RIGHT:
				diagram_pipe.rotation_degrees += PIPE_ROTATION_SPEED
				return
			return
	return






func on_game_started() -> void:
	pass

func on_game_finished() -> void:
	pass
