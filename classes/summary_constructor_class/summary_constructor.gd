@icon("res://assets/icons_classes/SummaryConstructorIcon.png")
class_name SummaryConstructor

extends Node

#Пути сцен кнопок в файловой системе
@export var buttons_paths : Dictionary = {
	"AcceptBtn" : "",
	"RejectBtn" : ""
}

#Массив с путями узлов маркеров позиций кнопок,
#заполняемый экземпляром этого класса
@export var button_markers : Array


@onready var buttons_pool : Node = $Buttons
@onready var mouse_shield : Control = $MouseShield
@onready var label : Label = $Label

#Массив с именами узлов уровней, которые вызываются в Менеджере Уровней
#при нажатии кнопок
var story_node_names : Array


#Загрузка, инстанцирование и позиционирование кнопок
func buttons_loading() -> void:
	for marker in button_markers:
		var marker_node = get_node(button_markers[button_markers.find(marker)])
		var word_index = marker_node.name.find("Position")
		var part_name = marker_node.name.substr(0, word_index)
		var temp_scene = load(buttons_paths[part_name])
		var button = temp_scene.instantiate()
		button.position = marker_node.position
		button.rotation = marker_node.rotation
		buttons_pool.add_child(button)

#ПОдключение сигналов кнопок к функции вызова определенного узла истории
func init_constructor() -> void:
	for button in buttons_pool.get_children():
		button.pressed.connect(on_button_pressed.bind(button, story_node_names))
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE

#Вызов определенного узла истории в соответствии с нажатой кнопкой
func on_button_pressed(button : TextureButton, names : Array) -> void:
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	if button.name == "SummaryAcceptBtn":
		Globals.story_manager.change_story_node(names[1])
	elif button.name == "SummaryRejectBtn":
		Globals.story_manager.change_story_node(names[0])

#Печать сообщения в рапорте
func print_summary(summary : String) -> void:
	label.text = summary
