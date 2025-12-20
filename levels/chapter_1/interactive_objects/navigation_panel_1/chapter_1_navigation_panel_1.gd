#chapter_1_navigation_panel_1.gd
extends LevelNavigationPanel

#Расширение функции обработки щелчка мыши на объекте
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.get_player().movement.check_player_position(Player.\
																Movement.PlayerPositions.SCREEN_2)
