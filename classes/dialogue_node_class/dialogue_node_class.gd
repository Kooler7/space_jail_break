@icon("res://assets/icons_classes/DialogueNodeIcon.png")
class_name DialogueNode

extends Node

#Тип узла диалога
enum NodeTypes {
	RANDOMIZER, ## Узел, автоматически переключающийся на случайный из массива random_nodes
	TEXT, ## Узел, отображающий текст
	OPTIONS, ## Узел, отображающий кнопки выбора
	ACTION ## Узел, содержащий действие в зависимости от current_action_type
}
@export var current_node_type : NodeTypes = NodeTypes.TEXT ## Тип узла диалога

#Тип действия, используемый для узла диалога типа Action
enum ActionTypes {
	SET_LEVEL_FLAG, ## Добавление значения флагу уровня
	SET_ITEM, ## Добавление элемента в инвентарь
	SET_GLOBAL_FLAG, ## Добавление значения глобальному флагу
	CHECK_INVENTORY, ## Проверка наличия элемента в инвентаре
	REMOVE_ITEM ## Удаление элемента из инвентаря
}
@export var current_action_type : ActionTypes = ActionTypes.SET_LEVEL_FLAG ## Тип действия для узла типа ACTION

#Вещи, полученные в процессе диалога, для добавления или удаления из инвентара
## Элементы, которые могут быть получены или потеряны в этом узле в
## процессе диалога, для добавления или удаления из инвентаря
@export var items : Array[String] = [] 


## Этапы повествования пройденные в процессе диалога для добавления в level_flags и global_flags
@export var flags : Array = [ 
	{
		"key" = "",
		"value" = false
	}
] 

## Имена узлов используемых для случайного начала диалога (если необходимо)
@export_category("For Randomizer!") 
@export var random_nodes : Array[String] = [] 


@export_category("For Text!")

@export var speaker : String = "Player" ##Имя спикера данного узла

@export_multiline var node_text : String = "" ##Текст узла диалога

@export var options : Array[PackedScene] = [] ##Сцены кнопок выбора опций из файловой системы

@export var next_node : String = "END" ##Имя следующего узла диалога

@export_category("For Action!")
#Название функции для вызова
@export var callable : String = "" ##Название функции для вызова
