extends Node2D


const DOOR_DAMAGE_MULTIPLIER = 0.8
const PipeDiagram = preload("res://levels/chapter_1/interactive_objects/open_door_game/force_diagram/force_diagram.gd")

enum ActionStates {
	STOPPED,
	STARTED,
	FINISHED,
	PLAYER_WON
}
var current_action_state : ActionStates = ActionStates.STOPPED


@onready var pipe : AnimatedSprite2D = $Pipe
@onready var door : Sprite2D = $Door
@onready var death_timer : Timer = $DeathTimer
@onready var shake_door : AnimationPlayer = $AnimationPlayer
@onready var ceiling_damage : TextureProgressBar = $CeilingDamage
@onready var door_damage : TextureProgressBar = $DoorDamage
@onready var diagram : PipeDiagram = $ForceDiagram


func _ready() -> void:
	check_action_state(ActionStates.STARTED)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_action_state == ActionStates.STARTED:
		ceiling_damage.value = death_timer.time_left
		
		if diagram.is_pipe_placed:
			door_damage.step = DOOR_DAMAGE_MULTIPLIER * delta
			door_damage.value = door_damage.value - door_damage.step
			print(door_damage.value)
		
		if door_damage.value <= door_damage.min_value:
			check_action_state(ActionStates.PLAYER_WON)
			print("PLAYER_WINS")




func check_action_state (new_state : ActionStates):
	if new_state != current_action_state:
		match new_state:
			ActionStates.STOPPED:
				current_action_state = ActionStates.STOPPED
			ActionStates.STARTED:
				diagram.is_started = true
				death_timer.start()
				diagram.calculate_new_diagram_angle()
				current_action_state = ActionStates.STARTED
			ActionStates.FINISHED:
				diagram.is_started = false
				diagram.is_pipe_placed = false
				death_timer.stop()
				shake_door.stop()
				diagram.diagram_timer.stop()
				print("DEAAAD!!!!")
				current_action_state = ActionStates.FINISHED
			ActionStates.PLAYER_WON:
				diagram.is_started = false
				diagram.is_pipe_placed = false
				diagram.diagram_timer.stop()
				death_timer.stop()
				shake_door.stop()
				door.hide()
				current_action_state = ActionStates.PLAYER_WON





func _on_death_timer_timeout() -> void:
	check_action_state(ActionStates.FINISHED)


func _on_force_diagram_pipe_placed() -> void:
	if pipe.frame_progress < 1:
		pipe.play()
	shake_door.play("shake_door")


func _on_force_diagram_pipe_lost_place() -> void:
	if pipe.frame!= 0:
		pipe.play_backwards()
		shake_door.stop()
