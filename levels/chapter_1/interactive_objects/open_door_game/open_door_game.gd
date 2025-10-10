extends Node2D

#signal pipe_angle_reached

@onready var pipe : AnimatedSprite2D = $Pipe
@onready var door : Sprite2D = $Door
@onready var death_timer : Timer = $DeathTimer
@onready var diagram : Sprite2D = $Stage2Items/Force
@onready var diagram_timer : Timer = $DiagramTimer
@onready var tip_1 :Label = $Stage2Items/Tip1
@onready var diagram_pipe : Sprite2D = $Stage2Items/DiagramPipe
@onready var shake_door : AnimationPlayer = $AnimationPlayer
@onready var stage_1_items : Node2D = $Stage1Items
@onready var stage_2_items : Node2D = $Stage2Items



const PIPE_TO_IDLE_SPEED : float = 10
const PIPE_ROTATION_SPEED : float = 2
const MIN_DIAGRAM_ANGLE : float = 0
const MAX_DIAGRAM_ANGLE : float = 180

enum GameStages {
	STAGE_1,
	STAGE_2,
	FINISHED,
	LOOSE
}
var current_game_stage : GameStages 
@export var new_stage : GameStages = GameStages.STAGE_1

var is_pipe_in_position : bool = false

func _ready() -> void:
	print(current_game_stage)
	print(new_stage)
	update_game_stage(new_stage)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if current_game_stage != new_stage:
		update_game_stage(new_stage)
	
	if current_game_stage == GameStages.STAGE_2:
		turn_pipe_to_idle(delta)
		scene_pipe_animation()


func update_game_stage(new_stage) -> void:
	match new_stage:
		GameStages.STAGE_1:
			stage_2_items.hide()
			stage_1_items.show()
			current_game_stage = GameStages.STAGE_1
		GameStages.STAGE_2:
			stage_1_items.hide()
			stage_2_items.show()
			current_game_stage = GameStages.STAGE_2
			diagram.rotation_degrees = randi_range(MIN_DIAGRAM_ANGLE, MAX_DIAGRAM_ANGLE)
			calculate_new_diagram_angle()
		GameStages.FINISHED:
			pass
		GameStages.LOOSE:
			pass

func scene_pipe_animation() -> void:
	if abs(diagram_pipe.rotation_degrees - diagram.rotation_degrees) < 10:
		if pipe.frame_progress < 1:
			pipe.play()
		shake_door.play("shake_door")
	elif abs(diagram_pipe.rotation_degrees - diagram.rotation_degrees) > 10:
		if pipe.frame!= 0:
			pipe.play_backwards()
			shake_door.stop()

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
	if current_game_stage == GameStages.STAGE_2:
		if diagram_pipe.rotation_degrees > 90:
			diagram_pipe.rotation_degrees -= PIPE_TO_IDLE_SPEED * delta
			return
		if diagram_pipe.rotation_degrees < 90:
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
