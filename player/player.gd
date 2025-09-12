#player.gd
class_name Player

extends Node2D

var player_decisions : Dictionary = {
	"Help_Dinia" : false,
}

var current_game_object : Node2D
var is_game_started : bool = false

@onready var avatar : Sprite2D = $PlayerAvatar
@onready var dialogue_manager : Node = $DialogueManager
@onready var game_object_holder : Node2D = $GameObject
@onready var camera : Camera2D = $Camera2D



func _ready() -> void:
	Settings.camera = camera
	Globals.player = self


func on_player_avatar_called() -> void:
	if current_game_object.avatar.modulate == current_game_object.avatar.FINISH_MODULATE:
		await current_game_object.avatar.popout()
	if avatar.modulate == avatar.START_MODULATE:
		await avatar.popin()

func on_npc_avatar_called() -> void:
	if avatar.modulate == avatar.FINISH_MODULATE:
		await avatar.popout()
	if current_game_object.avatar.modulate == current_game_object.avatar.START_MODULATE:
		await current_game_object.avatar.popin()

func on_game_object_clicked(scene : PackedScene) -> void:
	var new_scene : Node2D = scene.instantiate()
	game_object_holder.add_child(new_scene)
	current_game_object = game_object_holder.get_child(0)
	dialogue_manager.current_dialogue = current_game_object.dialogue
	dialogue_manager.parse_dialogue()

func on_dialogue_completed() -> void:
	await current_game_object.avatar.popout()
	dialogue_manager.current_dialogue = {}
	var child_to_remove = game_object_holder.get_child(0)
	child_to_remove.queue_free()
