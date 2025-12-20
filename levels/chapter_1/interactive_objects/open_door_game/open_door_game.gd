extends Node2D


const DOOR_DAMAGE_MULTIPLIER = 2
const PipeDiagram = preload("res://levels/chapter_1/interactive_objects/open_door_game/force_diagram/force_diagram.gd")

enum ActionStates {
	STOPPED,
	STARTED,
	FINISHED,
	PLAYER_WON
}
var _current_action_state : ActionStates = ActionStates.STOPPED


@onready var _pipe : AnimatedSprite2D = $Pipe
@onready var _door : Sprite2D = $Door
@onready var _death_timer : Timer = $DeathTimer
@onready var _shake_door : AnimationPlayer = $AnimationPlayer
@onready var _ceiling_damage : TextureProgressBar = $CeilingDamage
@onready var _door_damage : TextureProgressBar = $DoorDamage
@onready var _diagram : PipeDiagram = $ForceDiagram


func _ready() -> void:
	if self.get_parent() == get_tree().root:
		check_action_state(ActionStates.STARTED)
	else:
		GameState.connect("flag_changed", _on_level_flag)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _current_action_state == ActionStates.STARTED:
		_ceiling_damage.value = _death_timer.time_left
		
		if _diagram.get_pipe_place():
			_door_damage.step = DOOR_DAMAGE_MULTIPLIER * delta
			_door_damage.value = _door_damage.value - _door_damage.step
		
		if _door_damage.value <= _door_damage.min_value:
			check_action_state(ActionStates.PLAYER_WON)



func check_action_state (new_state : ActionStates):
	if new_state != _current_action_state:
		match new_state:
			ActionStates.STOPPED:
				_current_action_state = ActionStates.STOPPED
			ActionStates.STARTED:
				_diagram.set_diagram_activity(true)
				_death_timer.start()
				_current_action_state = ActionStates.STARTED
			ActionStates.FINISHED:
				_diagram.set_diagram_activity(false)
				_death_timer.stop()
				_shake_door.stop()
				_current_action_state = ActionStates.FINISHED
				Globals.player.update_health_state(Player.PlayerHealthStates.DEAD)
				Globals.get_story_manager().change_story_node("SummaryChapter1")
			ActionStates.PLAYER_WON:
				_diagram.set_diagram_activity(false)
				_death_timer.stop()
				_shake_door.stop()
				await _remove_door()
				GameState.set_flag(GameState.level_flags, "door_open", true)
				_current_action_state = ActionStates.PLAYER_WON


func _remove_door() -> void:
	var door_tween = create_tween()
	door_tween.tween_property(_door, "position", Vector2(-745, 0), 0.5)
	door_tween.play()
	await door_tween.finished
	return

func _on_level_flag(flag_name: String, flag_value: bool) -> void:
	if flag_name == "try_door" and flag_value == true:
		if _current_action_state == ActionStates.STOPPED:
			check_action_state(ActionStates.STARTED)


func _on_death_timer_timeout() -> void:
	check_action_state(ActionStates.FINISHED)


func _on_force_diagram_pipe_placed() -> void:
	if _pipe.frame_progress < 1:
		_pipe.play()
	_shake_door.play("shake_door")


func _on_force_diagram_pipe_lost_place() -> void:
	if _pipe.frame!= 0:
		_pipe.play_backwards()
		_shake_door.stop()
