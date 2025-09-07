@icon("res://assets/icons_classes/SummaryConstructorIcon.png")
class_name SummaryConstructor

extends Node


@export var buttons_paths : Dictionary = {
	"AcceptBtn" : "",
	"RejectBtn" : ""
}

@export var button_markers : Array
@export_multiline var summary_text : String
@onready var buttons_pool : Node = $Buttons

func buttons_loading() -> void:
	for marker in button_markers:
		var marker_node = get_node(button_markers[button_markers.find(marker)])
		var word_index = marker_node.name.find("Position")
		var part_name = marker_node.name.substr(0, word_index)
		var temp_scene = load(buttons_paths[part_name])
		var button = temp_scene.instantiate()
		button.position = marker_node.position
		buttons_pool.add_child(button)

func print_summary() -> void:
	var label = get_child(0)
	label.text = summary_text
	
