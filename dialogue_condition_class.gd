#dialogue_condition_class.gd
@icon("res://assets/icons_classes/DialogueConditionIcon.png")
class_name DialogueCondition
extends Node

@export_category("Условия для доступа к данному диалогу")
enum ConditionTypes {
	LEVEL_FLAG, ## Значение определенного этапа повествования на уровне
	GLOBAL_FLAG, ## Значение определенного глобального этапа повествования
	ITEM, ## Присутствие определенного элемента в инвентаре
	LEVEL_DECISION, ## Значение определенного решения на уровне
	GLOBAL_DECISION ## Значение определенного глобального решения
}

##Выбор типа условия доступности данного диалога
@export var condition_type : ConditionTypes

## Ключ этапа повествования в GameState.level_flags, GameState.global_flags,
## GameState.level_decisions, GameState.global_decisions 
@export_multiline var condition_key : String

##Ожидаемое значение ключа этапа повествования
@export var expected_value : bool 
