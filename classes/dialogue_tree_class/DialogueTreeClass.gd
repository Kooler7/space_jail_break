#DialogueTreeClass.gd
@icon("res://assets/icons_classes/DialogueTreeIcon.png")
class_name DialogueTree

extends Node

var tree_nodes : Array = []
var node_names : Array = []
@export var conditions: Dictionary = {
	"key" = "", 
	"expected_value" = false
	}


func _ready() -> void:
	tree_nodes = get_children()



#Функция получения искомого узла диалога по его имени
func get_node_safe(node_name: String) -> DialogueNode:
	for node in tree_nodes:
		node_names.push_back(node.name)
	if not node_names.has(node_name):
		push_error("DialogueTree: node '%s' not found!" % node_name)
		return null
	return tree_nodes[node_names.find(node_name)]


#Функция проверяющая доступность диалога
func is_available() -> bool:
	if GameState.level_flags.get(conditions.key) == conditions.expected_value:
		return true
	else:
		return false

func get_available_choices(node_id: String) -> Array:
	var node = get_node_safe(node_id)
	if not node or not node.is_available():
		return []
	var result = []
	for choice in node.choices:
		var choice_node = get_node_safe(choice.next_node)
		if choice_node and choice_node.is_available():
			result.append(choice)
	return result
