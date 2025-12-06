#DialogueTreeClass.gd
@icon("res://assets/icons_classes/DialogueTreeIcon.png")
class_name DialogueTree

extends Node

var tree_nodes : Array = []
var node_names : Array = []


#Условия при которых данное дерево диалога доступно для использования
@export var conditions: Array = [
	{
		"condition_type" = "",
		"key" = "", 
		"expected_value" = false
	}
]


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
	var temp_conditions : Array = []
	for condition in conditions:
		match condition.condition_type:
			"level_flag":
				if GameState.has_level_flag(condition.key):
					if GameState.level_flags[condition.key] == condition.expected_value:
						temp_conditions.push_back(true)
					else:
						temp_conditions.push_back(false)
				else:
					return false
			"item":
				if GameState.has_item(condition.key) == condition.expexted_value:
					temp_conditions.push_back(true)
				else:
					temp_conditions.push_back(false)
	if temp_conditions.has(false) or temp_conditions == null:
		return false
	else:
		return true

#func get_available_choices(node_id: String) -> Array:
	#var node = get_node_safe(node_id)
	#if not node or not node.is_available():
		#return []
	#var result = []
	#for choice in node.choices:
		#var choice_node = get_node_safe(choice.next_node)
		#if choice_node and choice_node.is_available():
			#result.append(choice)
	#return result
