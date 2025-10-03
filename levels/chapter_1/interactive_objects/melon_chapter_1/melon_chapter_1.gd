extends InteractiveObject

var constructed_name : String = "MELON_NPC"

func _ready() -> void:
	construct_object(constructed_name) 


func construct_object(constructed_name) -> void:
	super.construct_object(constructed_name)
	current_object_condition = ObjectConditions.TALK
