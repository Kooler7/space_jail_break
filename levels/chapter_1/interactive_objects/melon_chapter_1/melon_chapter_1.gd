extends InteractiveObject



func _ready() -> void:
	_dialogues = $Dialogues.get_children()



func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.set_current_object(self)
		DialogueManager.set_dialogue_tree()
		DialogueManager.start_dialogue()
