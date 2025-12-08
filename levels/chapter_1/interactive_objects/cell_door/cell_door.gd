#cell_door.gd
extends InteractiveObject



enum DoorStates {
	CLOSED,
	OPENED
}
var current_door_state : DoorStates = DoorStates.CLOSED



func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.current_object = self
		DialogueManager.current_dialogue = choose_dialogue()
		DialogueManager.start_dialogue()


func check_door_state(new_state) -> void:
	match new_state:
		DoorStates.CLOSED:
			current_door_state = DoorStates.CLOSED
			icon.show()
		DoorStates.OPENED:
			current_door_state = DoorStates.OPENED
			icon.hide()

func choose_dialogue() -> Dictionary:
	if current_door_state == DoorStates.CLOSED:
		if Globals.player.player_chapter_decisions["pipe_picked_up"] == false:
			pass
		elif Globals.player.player_chapter_decisions["pipe_picked_up"] == true:
			pass
		return {}
	elif current_door_state == DoorStates.OPENED:
		pass
	return {}
