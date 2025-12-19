extends InteractiveObject



func _on_mouse_detector_mouse_entered():
	if GameState.level_flags["melon_first_dialogue_complete"] == true:
		super._on_mouse_detector_mouse_entered()


func _on_mouse_detector_mouse_exited() -> void:
	if GameState.level_flags["melon_first_dialogue_complete"] == true:
		super._on_mouse_detector_mouse_exited()


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		if GameState.has_flag(GameState.level_flags, "pipe_picked_up") and GameState.\
							get_flag_value(GameState.level_flags, "melon_first_dialogue_complete"):
			GameState.set_flag(GameState.level_flags, "pipe_picked_up", true)
			GameState.add_item("pipe")
			queue_free()
		Globals.get_player().update_in_world_state(Player.PlayerInWorldStates.CAN_MOVE)
