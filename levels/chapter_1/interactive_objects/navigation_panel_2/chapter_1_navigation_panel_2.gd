extends LevelNavigationPanel


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.player_movement.check_player_position(Globals.player_movement.PlayerPositions.SCREEN_1)
