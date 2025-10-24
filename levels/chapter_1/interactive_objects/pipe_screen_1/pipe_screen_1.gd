extends InteractiveObject

var constructed_name : String = "PIPE"

func _ready() -> void:
	construct_object(constructed_name) 


func construct_object(new_constructed_name) -> void:
	super.construct_object(new_constructed_name)
	current_object_condition = ObjectConditions.TALK

func _on_mouse_detector_mouse_entered():
	if Globals.player.player_chapter_decisions["melon_first_dialogue_complete"] == true:
		super._on_mouse_detector_mouse_entered()


func _on_mouse_detector_mouse_exited() -> void:
	if Globals.player.player_chapter_decisions["melon_first_dialogue_complete"] == true:
		super._on_mouse_detector_mouse_exited()


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.player.player_chapter_decisions["pipe_picked_up"] = true
		Globals.player.update_action_state(Globals.player.LevelActionStates.IDLE)
		queue_free()
