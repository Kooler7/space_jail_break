#player.gd
class_name Player

extends Node2D

enum PlayerStates {
	EXPLANING,
	TALKING,
	INTERRACTING,
	IDLE
}
var current_player_state : PlayerStates = PlayerStates.IDLE

#var npc_data : Dictionary = {}
#var current_dialogue : Dictionary = {}
#var current_line : int = 1
var current_game_object : Node2D
#var child_to_remove : Node2D

@onready var gui : Control = $GUI
@onready var avatar : Sprite2D = $PlayerAvatar
@onready var dialogue_manager : Node = $DialogueManager
@onready var game_object_holder : Node2D = $GameObject


func _ready() -> void:
	Signals.game_object_clicked.connect(on_game_object_clicked)
	Signals.dialogue_completed.connect(on_dialogue_completed)
	Signals.player_avatar_called.connect(on_player_avatar_called)
	Signals.npc_avatar_called.connect(on_npc_avatar_called)
	pass



func on_player_avatar_called() -> void:
	if current_game_object.avatar.modulate == current_game_object.avatar.FINISH_MODULATE:
		await current_game_object.avatar.buddy_avatar_popout()
	if avatar.modulate == avatar.START_MODULATE:
		await avatar.avatar_popin()

func on_npc_avatar_called() -> void:
	if avatar.modulate == avatar.FINISH_MODULATE:
		await avatar.avatar_popout()
	if current_game_object.avatar.modulate == current_game_object.avatar.START_MODULATE:
		await current_game_object.avatar.buddy_avatar_popin()

func on_game_object_clicked(scene : PackedScene) -> void:
	var new_scene : Node2D = scene.instantiate()
	game_object_holder.add_child(new_scene)
	current_game_object = game_object_holder.get_child(0)
	dialogue_manager.current_dialogue = current_game_object.dialogue
	dialogue_manager.parse_dialogue()

func on_dialogue_completed() -> void:
	await current_game_object.avatar.buddy_avatar_popout()
	dialogue_manager.current_dialogue = {}
	var child_to_remove = game_object_holder.get_child(0)
	child_to_remove.queue_free()
