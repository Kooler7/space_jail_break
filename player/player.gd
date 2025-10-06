#player.gd
class_name Player

extends Node2D

const MouseShieldRed = Color(1, 0, 0, 0.2)
const MouseShieldGray = Color(0, 0, 0, 0.5)
const MouseShieldDefault = Color(0, 0, 0, 0)

var reached_level : String = ""

var player_global_decisions : Dictionary = {
	"HelpMelonInCell" : false,
}
var player_chapter_decisions : Dictionary

var is_player_alive : bool = true
#var is_game_started : bool = false

@onready var avatar_position : Marker2D = $AvatarPosition
@onready var player_avatar : ChacrterAvatarClass = $AvatarPosition/PlayerAvatar
@onready var camera : Camera2D = $Camera2D
@onready var mouse_shield : ColorRect = $MouseShield
@onready var explaner : Node2D = $Explaner
@onready var dialogue_box : TextureRect = $DialogueBox

var current_npc_avatar : PackedScene
var npc_avatar : ChacrterAvatarClass
var showed_avatar : ChacrterAvatarClass

func _ready() -> void:
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_shield.color = MouseShieldDefault
	Settings.camera = camera
	Globals.player = self



func add_object_avatar() -> void:
	npc_avatar = current_npc_avatar.instantiate()
	avatar_position.add_child(npc_avatar)

func remove_object_avatar() -> void:
	current_npc_avatar = null
	npc_avatar = null
	showed_avatar = null
	var avatars : Array = avatar_position.get_children()
	for avatar in avatars:
		var temp_name : String = avatar.name
		if temp_name.begins_with("Player") == false:
			avatar.queue_free()

func on_avatar_called(new_avatar : ChacrterAvatarClass) -> void:
	if showed_avatar != null:
		if showed_avatar == new_avatar:
			return
		elif showed_avatar != new_avatar:
			await showed_avatar.popout()
			showed_avatar = new_avatar
			await new_avatar.popin()
			return
	elif showed_avatar == null:
		showed_avatar = new_avatar
		await new_avatar.popin()
		return

func on_avatar_dismissed() -> void:
	if showed_avatar != null:
		await showed_avatar.popout()
	return


func on_game_object_hovered(new_text: String)-> void:
	explaner.text.text = new_text
	explaner.popin()

func on_game_object_unhovered()-> void:
	explaner.popout()

func on_dialogue_started() ->void:
	explaner.popout()
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_shield.color = MouseShieldGray
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC: 
		add_object_avatar()
	await dialogue_box.dialogue_box_popin()
	return

func on_dialogue_completed() -> void:
	dialogue_box.remove_options()
	await dialogue_box.dialogue_box_popout()
	dialogue_box.text_field.text = ""
	await on_avatar_dismissed()
	remove_object_avatar()
	mouse_shield.color = MouseShieldDefault
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return
