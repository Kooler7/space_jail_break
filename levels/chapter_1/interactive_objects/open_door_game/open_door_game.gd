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
	if self.get_parent() == get_tree().root:
		check_action_state(ActionStates.STARTED)
	else:
		GameState.connect("flag_changed", _on_level_flag)


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
				current_action_state = ActionStates.FINISHED
				Globals.player.update_health_state(Player.PlayerHealthStates.DEAD)
				Globals.story_manager.change_story_node("SummaryChapter1")
			ActionStates.PLAYER_WON:
				diagram.is_started = false
				diagram.is_pipe_placed = false
				diagram.diagram_timer.stop()
				death_timer.stop()
				shake_door.stop()
				door.hide()
				GameState.set_flag(GameState.level_flags, "door_open", true)
				Globals.player.movement.check_player_position(Globals.player.movement.PlayerPositions.SCREEN_2)
				current_action_state = ActionStates.PLAYER_WON


func _on_level_flag(flag_name: String, flag_value: bool) -> void:
	if flag_name == "try_door" and flag_value == true:
		check_action_state(ActionStates.STARTED)


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
