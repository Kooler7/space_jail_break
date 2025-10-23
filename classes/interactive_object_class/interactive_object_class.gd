#interactive_object_class.gd
@icon("res://assets/icons_classes/InteractiveObjectIcon.png")
class_name InteractiveObject

extends Node2D

@export var icon_texture : Texture2D
@export var detector_shape : Shape2D

@onready var icon : Sprite2D = $Icon
@onready var mouse_detector : Area2D = $MouseDetector
@onready var object_name : Label = $Name

const IDLE_DOOR_MODULATE = Color(1, 1, 1, 1)
const HOVER_DOOR_MODULATE = Color(1.5, 1.5, 1.5, 1)

enum ObjectTypes {
	NPC,
	ENVIRONMENT
}
@export var object_type : ObjectTypes

enum ObjectConditions {
	TALK,
	INTERACT,
	IGNORE
}
var current_object_condition : ObjectConditions = ObjectConditions.IGNORE


func construct_object(constructed_object_name : String) -> void:
	icon.texture = icon_texture
	mouse_detector.get_child(0).shape = detector_shape
	object_name.text = constructed_object_name

func on_dialogue_started() -> void:
	toggle_pickable()

func on_dialogue_completed() -> void:
	toggle_pickable()


func toggle_pickable() -> void:
	if mouse_detector.input_pickable == true:
		mouse_detector.input_pickable = false
	elif mouse_detector.input_pickable == false:
		mouse_detector.input_pickable = true


func _on_mouse_detector_mouse_entered() -> void:
	if current_object_condition != ObjectConditions.IGNORE:
		Globals.player.action_text = object_name.text
		Globals.player.update_action_state(Globals.player.LevelActionStates.EXPLAIN)
		icon.modulate = HOVER_DOOR_MODULATE


func _on_mouse_detector_mouse_exited() -> void:
	if current_object_condition != ObjectConditions.IGNORE:
		Globals.player.update_action_state(Globals.player.LevelActionStates.IDLE)
		icon.modulate = IDLE_DOOR_MODULATE


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
