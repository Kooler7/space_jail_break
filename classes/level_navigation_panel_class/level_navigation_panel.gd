@icon("res://assets/icons_classes/LevelNavigationPanel.png")
class_name LevelNavigationPanel
extends Node2D

@onready var arrow : Sprite2D = $Sprite2D




func _on_area_2d_mouse_entered() -> void:
	arrow.show()


func _on_area_2d_mouse_exited() -> void:
	arrow.hide()




func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pass
