#level_navigation_panel.gd
@icon("res://assets/icons_classes/LevelNavigationPanel.png")
class_name LevelNavigationPanel
extends Node2D

@onready var _arrow : Sprite2D = $Sprite2D

#Функция обработки ввода мыши на объект
func _on_area_2d_mouse_entered() -> void:
	_arrow.show()

#Функция вывода мыши из объекта
func _on_area_2d_mouse_exited() -> void:
	_arrow.hide()

#Функция обработки щелчка мыши на объекте
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pass
