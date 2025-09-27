#cell_door.gd
extends InteractiveObject

@onready var closed_no_pipe_dialogue : Node = $DoorClosedNoPipe
@onready var closed_pipe_dialogue : Node = $DoorClosedPipe


enum DoorStates {
	CLOSED,
	OPENED
}
var current_door_state : DoorStates = DoorStates.CLOSED


func _ready() -> void:
	construct_door()

func construct_door() -> void:
	icon.texture = load("res://assets/chapter_1/images/Cell_Door.png")
	mouse_detector.get_child(0).shape = load("res://resources/collision_shapes/cell_door_collision_shape.tres")
	mouse_detector.position = $CollisionPosition.position
	mouse_detector.mouse_entered.connect(on_mouse_entered)
	mouse_detector.mouse_exited.connect(on_mouse_exited)
	mouse_detector.input_event.connect(on_mouse_input_event)
	object_name.text = "CELL_DOOR"
	current_object_condition = ObjectConditions.TALK

func on_mouse_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle_pickable()
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

func on_dialogue_completed() -> void:
	toggle_pickable()
