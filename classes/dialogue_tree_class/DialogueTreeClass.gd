#DialogueTreeClass.gd
@icon("res://assets/icons_classes/DialogueTreeIcon.png")
class_name DialogueTree

extends Node

var tree_nodes : Array = []
var node_names : Array = []


#Условия при которых данное дерево диалога доступно для использования
@export_category("Add Conditions!")
@export var conditions : Array[DialogueCondition] = [] ## Условия при которых данное дерево диалога доступно для использования


func _ready() -> void:
	tree_nodes = get_children()



##Функция получения искомого узла диалога по его имени
func get_node_safe(node_name: String) -> DialogueNode:
	for node in tree_nodes:
		node_names.push_back(node.name)
	if not node_names.has(node_name):
		push_error("DialogueTree: node '%s' not found!" % node_name)
		return null
	return tree_nodes[node_names.find(node_name)]


##Функция проверяющая доступность диалога
func is_available() -> bool:
	#Возврат если уловия не указаны
	if conditions == []:
		return false
	
	var temp_conditions : Array = []
	for condition in conditions:
		match condition.condition_type:
			
			#Действия если условие для доступа к диалогу в сюжетных флагах уровня
			condition.ConditionTypes.LEVEL_FLAG:
				if GameState.has_flag(GameState.level_flags, condition.condition_key):
					if GameState.level_flags[condition.condition_key] == condition.expected_value:
						temp_conditions.push_back(true)
					else:
						temp_conditions.push_back(false)
				else:
					return false
			
			#Действия если условие для доступа к диалогу в инвентаре
			condition.ConditionTypes.ITEM:
				if GameState.has_item(condition.condition_key) == condition.expected_value:
					temp_conditions.push_back(true)
				else:
					temp_conditions.push_back(false)
			
			#Действия если условие для доступа к диалогу в сюжетных глобальных флагах
			condition.ConditionTypes.GLOBAL_FLAG:
				pass
			
			#Действия если условие для доступа к диалогу в решениях на уровне
			condition.ConditionTypes.LEVEL_DECISION:
				pass
			
			#Действия если условие для доступа к диалогу в глобальных решениях
			condition.ConditionTypes.GLOBAL_DECISION:
				pass
	
	#Если не выполнено хотябы одно из условий, то диалог недоступен
	if temp_conditions.has(false) or temp_conditions == null:
		return false
	else:
		return true
