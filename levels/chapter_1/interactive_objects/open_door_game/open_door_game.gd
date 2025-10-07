extends Node2D

signal pipe_angle_reached

@onready var pipe : AnimatedSprite2D = $Pipe
@onready var door : Sprite2D = $Door
@onready var death_timer : Timer = $DeathTimer
@onready var diagram : Sprite2D = $Force
@onready var diagram_timer : Timer = $DiagramTimer
@onready var tip_1 :Label = $Tip1
@onready var diagram_pipe : Sprite2D = $DiagramPipe
@onready var reached_timer : Timer = $ReachedTimer

enum GameStages {
	STAGE_1,
	STAGE_2,
	FINISHED,
	LOOSE
}
var current_game_stage : GameStages = GameStages.STAGE_1
@export var new_stage : GameStages = GameStages.STAGE_1
#func _ready() -> void:
	#calculate_new_angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_game_stage(new_stage)
	turn_pipe_to_idle(delta)
	scene_pipe_animation()
	

func update_game_stage(new_stage) -> void:
	if current_game_stage != new_stage:
		match new_stage:
			GameStages.STAGE_1:
				pass
			GameStages.STAGE_2:
				tip_1.show()
				diagram.show()
				current_game_stage = GameStages.STAGE_2
				diagram.rotation_degrees = randi_range(-90, 90)
				calculate_new_diagram_angle()
			GameStages.FINISHED:
				pass
			GameStages.LOOSE:
				pass

func scene_pipe_animation() -> void:
	if current_game_stage == GameStages.STAGE_2:
		if abs(abs(diagram_pipe.rotation_degrees) - abs(diagram.rotation_degrees)) < 5:
			if pipe.is_playing() == false:
				reached_timer.start()
				await reached_timer.timeout
				pipe.play()
			return
		elif abs(abs(diagram_pipe.rotation_degrees) - abs(diagram.rotation_degrees)) > 5:
			if pipe.is_playing() == false:
				pipe.play_backwards()
			return
			

func calculate_new_diagram_angle() -> void:
	if current_game_stage == GameStages.STAGE_2:
		diagram_timer.wait_time = randi_range(1, 3)
		diagram_timer.start()
		await  diagram_timer.timeout
		var take_angle = randi_range(0, 1)
		if take_angle == 1:
			var angle = randi_range(-90, 90)
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
			diagram_pipe.rotation_degrees -= 10 * delta
			return
		if diagram_pipe.rotation_degrees < 0:
			diagram_pipe.rotation_degrees += 10 * delta
			return
	return


func  _input(event: InputEvent) -> void:
	if current_game_stage == GameStages.STAGE_2:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				diagram_pipe.rotation_degrees -= 2
				return
			if event.button_index == MOUSE_BUTTON_RIGHT:
				diagram_pipe.rotation_degrees += 2
				return
			return
	return


func on_game_started() -> void:
	pass

func on_game_finished() -> void:
	pass
