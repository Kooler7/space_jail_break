extends Sprite2D

enum NpcActionsStates {
	IDLE,
	TALKING
}
var current_action_state : NpcActionsStates = NpcActionsStates.IDLE

var trasfered_data : Dictionary
var current_dialogue_line : String
var current_dialogue_key : int = 0

var dialogue : Dictionary = {
	0 : "Это ты, Змей? Что-то мне, кореш, не фортануло...",
	1 : [
		"res://levels/chapter_1/dialogues/options/how_to_help.tscn",
		"res://levels/chapter_1/dialogues/options/leave.tscn"	
	],
	2 : "Дай мне обезбола. Не то я окочурюсь от болевого шока."
}

#func _ready() -> void:
	#Signals.dialogue_box_clicked.connect()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		dialogue_parsing()
		



func _on_area_2d_mouse_entered() -> void:
	if current_action_state == NpcActionsStates.IDLE:
		trasfered_data = {"name" : name}
		Signals.emit_signal("game_object_mouse_entered", trasfered_data)


func _on_area_2d_mouse_exited() -> void:
	Signals.emit_signal("game_object_mouse_exited", trasfered_data)

func dialogue_parsing() -> void:
	if typeof(dialogue[current_dialogue_key]) == 4:
		trasfered_data = {"dialogue_text" : dialogue[current_dialogue_key]}
		Signals.emit_signal("npc_mouse_clicked", trasfered_data)
	elif typeof(dialogue[current_dialogue_key]) == 28:
		pass
