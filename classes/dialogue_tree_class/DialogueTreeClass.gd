#DialogueTreeClass.gd
@icon("res://assets/icons_classes/DialogueTreeIcon.png")
class_name DialogueTree

extends Node

var tree_nodes : Array = []
var node_names : Array = []
var temp_conditions : Array = []



#Условия при которых данное дерево диалога доступно для использования
@export_category("Add Conditions!")
## Условия при которых данное дерево диалога доступно для использования
@export var conditions : Array[DialogueCondition] = [] 


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
	
	temp_conditions = []
	
	#Цикл проверки каждого условия из массива условий
	for condition in conditions:
		match condition.condition_type:
			
			#Действия если условие для доступа к диалогу в сюжетных флагах уровня
			condition.ConditionTypes.LEVEL_FLAG:
				temp_conditions.push_back(check_condition(GameState.level_flags, condition.condition_key, condition.expected_value))

			#Действия если условие для доступа к диалогу в инвентаре
			condition.ConditionTypes.ITEM:
				temp_conditions.push_back(check_item(condition.condition_key, condition.expected_value))

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


#Функция проверки элемента в инвентаре
func check_item(item: String, expected_value: bool) -> bool:
	if GameState.has_item(item) == expected_value:
		return true
	else:
		return false

#Функция проверки глобального этапа\решения или этапа\решения уровня
func check_condition(storage: Dictionary, condition_key: String, expected_value: bool) -> bool:
	if GameState.has_flag(storage, condition_key):
		if storage[condition_key] == expected_value:
			return true
		else:
			return false
	else:
		return false
