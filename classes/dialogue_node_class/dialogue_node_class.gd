@icon("res://assets/icons_classes/DialogueNodeIcon.png")
class_name DialogueNode

extends Node

#Тип узла диалога
enum NodeTypes {
	RANDOMIZER,
	TEXT,
	OPTIONS,
	ACTION
}
@export var current_node_type : NodeTypes = NodeTypes.TEXT

#Тип действия, используемый для узла диалога типа Action
enum ActionTypes {
	SET_LEVEL_FLAG,
	SET_ITEM,
	SET_GLOBAL_FLAG,
	REMOVE_ITEM
}
@export var current_action_type : ActionTypes = ActionTypes.SET_LEVEL_FLAG

#Вещи, полученные в процессе диалога, для добавления или удаления из инвентара
@export var items : Array = []

#Этапы повествования пройденные в процессе диалога для добавления в level_flags и global_flags
@export var flags : Array = [
	{
		"key" = "",
		"value" = false
	}
]

#Имена узлов используемых для случайного начала диалога (если необходимо)
@export var random_nodes : Array = []

#Имя спикера данного узла
@export var speaker : String = "Player"

#Текст узла диалога
@export_multiline var node_text : String = ""

#Адреса кнопок выбора опций
@export var options : Array = []

#Название функции для вызова
@export var callable : String = ""

#Имя следующего узла диалога
@export var next_node : String = "END"
