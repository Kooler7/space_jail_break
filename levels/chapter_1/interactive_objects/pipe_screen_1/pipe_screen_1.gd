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
