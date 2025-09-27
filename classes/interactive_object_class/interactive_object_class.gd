#interactive_object_class.gd
@icon("res://assets/icons_classes/InteractiveObjectIcon.png")
class_name InteractiveObject

extends Node2D

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

func toggle_pickable() -> void:
	if mouse_detector.input_pickable == true:
		mouse_detector.input_pickable = false
	elif mouse_detector.input_pickable == false:
		mouse_detector.input_pickable = true

func on_mouse_entered() -> void:
	if current_object_condition != ObjectConditions.IGNORE:
		Globals.player.on_game_object_hovered(object_name.text)
		icon.modulate = HOVER_DOOR_MODULATE


func on_mouse_exited() -> void:
	if current_object_condition != ObjectConditions.IGNORE:
		Globals.player.on_game_object_unhovered()
		icon.modulate = IDLE_DOOR_MODULATE


func on_mouse_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
