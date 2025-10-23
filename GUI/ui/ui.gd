extends Control

#Константы для блокиратора мыши
const MouseShieldRed = Color(1, 0, 0, 0.2)
const MouseShieldGray = Color(0, 0, 0, 0.5)
const MouseShieldDefault = Color(0, 0, 0, 0)

enum UiStates {
	DEAD,
	SPEAK,
	LISTEN,
	EXPLAIN,
	INTERACT,
	IDLE,
	PAUSED,
	ACTIVE,
	INACTIVE
}
var current_ui_state : UiStates = UiStates.IDLE

var action_text : String = ""
var current_npc_avatar : PackedScene
var npc_avatar : ChacrterAvatarClass
var showed_avatar : ChacrterAvatarClass

@onready var avatar_position : Marker2D = $AvatarPosition
@onready var player_avatar : ChacrterAvatarClass = $AvatarPosition/PlayerAvatar
@onready var mouse_shield : ColorRect = $MouseShield
@onready var explaner : Node2D = $Explaner
@onready var dialogue_box : TextureRect = $DialogueBox

@export var dialogue_avatars : Array

func  _ready() -> void:
	mouse_shield.color = MouseShieldDefault


func update_ui_state(new_state : UiStates) -> void:
	match new_state:
		
		UiStates.DEAD:
			pass
		
		UiStates.SPEAK:
			mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
			mouse_shield.color = MouseShieldGray
			if current_ui_state == UiStates.EXPLAIN:
				hide_explainer()
				await on_dialogue_started()
			await on_avatar_called(player_avatar)
			await dialogue_box.text_typing(action_text)
			current_ui_state = UiStates.SPEAK
			return
		
		UiStates.LISTEN:
			mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
			mouse_shield.color = MouseShieldGray
			if current_ui_state == UiStates.EXPLAIN:
				hide_explainer()
				await on_dialogue_started()
			await on_avatar_called(npc_avatar)
			await dialogue_box.text_typing(action_text)
			current_ui_state = UiStates.LISTEN
			return
		
		UiStates.EXPLAIN:
			show_explainer()
			current_ui_state = UiStates.EXPLAIN
		
		UiStates.INTERACT:
			pass
		
		UiStates.IDLE:
			match  current_ui_state:
				UiStates.EXPLAIN:
					hide_explainer()
				UiStates.SPEAK or UiStates.LISTEN:
					mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
					mouse_shield.color = MouseShieldDefault
					await on_dialogue_completed()
					await on_avatar_dismissed()
					remove_object_avatar()
			current_ui_state = UiStates.IDLE
		UiStates.PAUSED:
			pass
		UiStates.ACTIVE:
			mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
			current_ui_state = UiStates.ACTIVE
		UiStates.INACTIVE:
			mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_STOP)
			current_ui_state = UiStates.INACTIVE


func show_explainer()-> void:
	explaner.text.text = action_text
	explaner.popin()

func hide_explainer()-> void:
	explaner.popout()
	explaner.text.text = ""

func on_dialogue_started() ->void:
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC: 
		npc_avatar = current_npc_avatar.instantiate()
		avatar_position.add_child(npc_avatar)
	await dialogue_box.dialogue_box_popin()
	return


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

func on_dialogue_completed() -> void:
	dialogue_box.remove_options()
	await dialogue_box.dialogue_box_popout()
	dialogue_box.text_field.text = ""
	return
