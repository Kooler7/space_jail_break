extends Control

#Константы для блокиратора мыши
const MouseShieldRed = Color(1, 0, 0, 0.2)
const MouseShieldGray = Color(0, 0, 0, 0.7)
const MouseShieldDefault = Color(0, 0, 0, 0)
const PauseMenu = preload("res://GUI/pause_menu/pause_menu.gd")


@onready var mouse_shield : ColorRect = $MouseShield
@onready var explaner : Node2D = $Explaner
@onready var pause_menu : PauseMenu = $PauseMenu


func  _ready() -> void:
	mouse_shield.color = MouseShieldDefault


func toggle_mouse_shield(new_color : Color, mouse_filter_state : int) -> void:
	mouse_shield.color = new_color
	mouse_shield.set_mouse_filter(mouse_filter_state)



func show_explainer(text : String)-> void:
	explaner.text.text = text 
	explaner.popin()

func hide_explainer()-> void:
	explaner.popout()
	explaner.text.text = ""


#func on_dialogue_started() ->void:
	#if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC: 
		#npc_avatar = current_npc_avatar.instantiate()
		#avatar_position.add_child(npc_avatar)
	#return


#func remove_object_avatar() -> void:
	#current_npc_avatar = null
	#npc_avatar = null
	#showed_avatar = null
	#var avatars : Array = avatar_position.get_children()
	#for avatar in avatars:
		#var temp_name : String = avatar.name
		#if temp_name.begins_with("Player") == false:
			#avatar.queue_free()
#
#
#func on_avatar_called(new_avatar : ChacrterAvatarClass) -> void:
	#if showed_avatar != null:
		#if showed_avatar == new_avatar:
			#return
		#elif showed_avatar != new_avatar:
			#await showed_avatar.popout()
			#showed_avatar = new_avatar
			#await new_avatar.popin()
			#return
	#elif showed_avatar == null:
		#showed_avatar = new_avatar
		#await new_avatar.popin()
		#return
#
#func on_avatar_dismissed() -> void:
	#if showed_avatar != null:
		#await showed_avatar.popout()
	#return
#
#func on_dialogue_completed() -> void:
	#dialogue_box.update_visibility_state(dialogue_box.VisibilityStates.REMOVE_OPTIONS)
	#await dialogue_box.update_visibility_state(dialogue_box.VisibilityStates.POP_OUT)
	#dialogue_box.text_field.text = ""
	#return
