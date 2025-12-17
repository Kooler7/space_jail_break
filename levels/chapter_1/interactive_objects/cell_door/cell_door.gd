#cell_door.gd
extends InteractiveObject



enum DoorStates {
	CLOSED,
	OPENED
}
var current_door_state : DoorStates = DoorStates.CLOSED

func _ready() -> void:
	GameState.flag_changed.connect(check_door_state.bind(DoorStates.OPENED))
	dialogues = $Dialogues.get_children()

func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.current_object = self
		if dialogues != null:
			for dialogue in dialogues:
				if dialogue.is_available():
					DialogueManager.set_dialogue_tree(dialogue)
					DialogueManager.start_dialogue()



func check_door_state(flag_name: String, flag_value: bool, new_state: DoorStates) -> void:
	if flag_name == "door_open" and flag_value == true:
		match new_state:
			DoorStates.CLOSED:
				current_door_state = DoorStates.CLOSED
				icon.show()
			DoorStates.OPENED:
				current_door_state = DoorStates.OPENED
				icon.hide()
