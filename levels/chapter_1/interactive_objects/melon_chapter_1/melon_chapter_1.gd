extends InteractiveObject


var constructed_name : String = "MELON_NPC"
var dialogues : Array

func _ready() -> void:
	construct_object(constructed_name)
	dialogues = $Dialogues.get_children()


func construct_object(new_constructed_name) -> void:
	super.construct_object(new_constructed_name)
	current_object_condition = ObjectConditions.TALK


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.current_object = self
		for dialogue in dialogues:
			if dialogue.is_available():
				DialogueManager.current_dialogue_tree = dialogue
		DialogueManager.start_dialogue()
