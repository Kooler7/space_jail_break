#cell_door.gd
extends InteractiveObject

@onready var closed_no_pipe_dialogue : Node = $DoorClosedNoPipe
@onready var closed_pipe_dialogue : Node = $DoorClosedPipe

var constructed_name : String = "CELL_DOOR"

enum DoorStates {
	CLOSED,
	OPENED
}
var current_door_state : DoorStates = DoorStates.CLOSED


func _ready() -> void:
	construct_object(constructed_name) 


func construct_object(constructed_name) -> void:
	super.construct_object(constructed_name)
	mouse_detector.position = $CollisionPosition.position
	current_object_condition = ObjectConditions.TALK

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
			return closed_no_pipe_dialogue.dialogue
		elif Globals.player.player_chapter_decisions["pipe_picked_up"] == true:
			return closed_pipe_dialogue.dialogue
		return {}
	elif current_door_state == DoorStates.OPENED:
		pass
	return {}
