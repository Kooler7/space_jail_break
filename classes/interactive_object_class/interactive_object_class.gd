#interactive_object_class.gd
@icon("res://assets/icons_classes/InteractiveObjectIcon.png")
class_name InteractiveObject

extends Node2D


@export var object_name : String

@onready var icon : Sprite2D = $Icon
@onready var mouse_detector : Area2D = $MouseDetector

const IDLE_MODULATE = Color(1, 1, 1, 1)
const HOVER_MODULATE = Color(1.8, 1.8, 1.8, 1)

var dialogues : Array

func toggle_pickable() -> void:
	if mouse_detector.input_pickable == true:
		mouse_detector.input_pickable = false
	elif mouse_detector.input_pickable == false:
		mouse_detector.input_pickable = true


func _on_mouse_detector_mouse_entered() -> void:
	Globals.player.explainer_text = object_name
	Globals.player.update_in_world_state(Player.PlayerInWorldStates.EXPLAIN)
	icon.modulate = HOVER_MODULATE


func _on_mouse_detector_mouse_exited() -> void:
	Globals.player.update_in_world_state(Player.PlayerInWorldStates.CAN_MOVE)
	icon.modulate = IDLE_MODULATE


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
