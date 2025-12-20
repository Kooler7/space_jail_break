#DialogueTreeClass.gd
@icon("res://assets/icons_classes/DialogueTreeIcon.png")
class_name DialogueTree

extends Node

var _tree_nodes : Array = []
var _temp_conditions : Array = []



#Условия при которых данное дерево диалога доступно для использования
@export_category("Add Conditions!")
## Условия при которых данное дерево диалога доступно для использования
@export var conditions : Array[DialogueCondition] = [] 


func _ready() -> void:
	_tree_nodes = get_children()



##Функция получения искомого узла диалога по его имени
func get_node_safe(node_name: String) -> DialogueNode:
	for node in _tree_nodes:
		if node.name == node_name:
			return node
	return null



##Функция проверяющая доступность диалога
func is_available() -> bool:
	#Возврат если уловия не указаны
	if conditions == []:
		return false
	
	_temp_conditions = []
	
	#Цикл проверки каждого условия из массива условий
	for condition in conditions:
		match condition.condition_type:
			
			#Действия если условие для доступа к диалогу в сюжетных флагах уровня
			condition.ConditionTypes.LEVEL_FLAG:
				_temp_conditions.push_back(_check_condition(GameState.\
									level_flags, condition.condition_key, condition.expected_value))

			#Действия если условие для доступа к диалогу в инвентаре
			condition.ConditionTypes.ITEM:
				_temp_conditions.push_back(_check_item(condition.\
															condition_key, condition.expected_value))

			#Действия если условие для доступа к диалогу в сюжетных глобальных флагах
			condition.ConditionTypes.GLOBAL_FLAG:
				_temp_conditions.push_back(_check_condition(GameState.\
									global_flags, condition.condition_key, condition.expected_value))
			
			#Действия если условие для доступа к диалогу в решениях на уровне
			condition.ConditionTypes.LEVEL_DECISION:
				_temp_conditions.push_back(_check_condition(GameState.\
								level_decisions, condition.condition_key, condition.expected_value))
			
			#Действия если условие для доступа к диалогу в глобальных решениях
			condition.ConditionTypes.GLOBAL_DECISION:
				_temp_conditions.push_back(_check_condition(GameState.\
								global_decisions, condition.condition_key, condition.expected_value))

	#Если не выполнено хотябы одно из условий, то диалог недоступен
	if _temp_conditions.has(false) or _temp_conditions == null:
		return false
	else:
		return true


#Функция проверки элемента в инвентаре
func _check_item(item: String, expected_value: bool) -> bool:
	if GameState.has_item(item) == expected_value:
		return true
	else:
		return false

#Функция проверки глобального этапа\решения или этапа\решения уровня
func _check_condition(storage: Dictionary, condition_key: String, expected_value: bool) -> bool:
	if GameState.get_flag_value(storage, condition_key) == expected_value:
		return true
	return false
