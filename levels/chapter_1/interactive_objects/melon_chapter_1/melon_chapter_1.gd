extends InteractiveObject

@onready var first_dialogue : Node = $MelonFirstDialogue
@onready var pipe_dialogue : Node = $MelonPipeDialogue

@export var avatar : PackedScene

var constructed_name : String = "MELON_NPC"

func _ready() -> void:
	construct_object(constructed_name)



func construct_object(new_constructed_name) -> void:
	super.construct_object(new_constructed_name)
	current_object_condition = ObjectConditions.TALK



func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.current_object = self
		DialogueManager.current_dialogue = choose_dialogue()
		DialogueManager.start_dialogue()


func choose_dialogue() -> Dictionary:
	if Globals.player.player_chapter_decisions["melon_first_dialogue_complete"] == false:
		return first_dialogue.dialogue
	if Globals.player.player_chapter_decisions["pipe_picked_up"] and Globals.player.player_chapter_decisions["door_open"] == false:
		return pipe_dialogue.dialogue
	return {}

#func on_npc_avatar_called() -> void:
	#await avatar.popin()
#
#func on_npc_avatar_dismissed() -> void:
	#await avatar.popout()
