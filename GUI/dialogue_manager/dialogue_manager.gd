#dialogue_manager.gd
class_name DialogueManager
extends Node2D


var current_dialogue : Dictionary = {}
var current_line_number : int = 1

@onready var dialogue_box : TextureRect = $DialogueBox
@onready var mouse_stop_area : Control = $MouseStopArea

func _ready() -> void:
	Globals.dialogue_manager = self
	mouse_stop_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#Signals.dialogue_box_clicked.connect(on_dialogue_box_clicked)
	#Signals.leave_option_clicked.connect(on_leave_option_clicked)
	#Signals.new_line_requested.connect(parse_dialogue)

func on_leave_option_clicked() -> void:
	current_line_number = 1
	dialogue_box.dialogue_box_popout()
	mouse_stop_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#Signals.emit_signal("dialogue_completed")
	Globals.current_npc.toggle_pickable()
	Globals.current_npc = null
	Globals.player.on_dialogue_completed()


##Обработка сигнала "dialogue_box_clicked"
func on_dialogue_box_clicked() -> void:
	#Проверка номера строки не больше размера диалога
	if current_line_number <= current_dialogue.size():
		#Запуск обработки диалога
		parse_dialogue()
	else:
		#Запуск сигнала об окончании диалога и сброс текстового поля до нуля и
		#присвоение номера строки "по умолчанию"
		current_line_number = 1
		dialogue_box.dialogue_box_popout()
		mouse_stop_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#Signals.emit_signal("dialogue_completed")
		Globals.current_npc.toggle_pickable()
		Globals.player.on_dialogue_completed()

	pass

func parse_dialogue(line_number : int = current_line_number) -> void:
	mouse_stop_area.mouse_filter = Control.MOUSE_FILTER_STOP
	if dialogue_box.modulate != dialogue_box.FINISH_MODULATE:
		dialogue_box.dialogue_box_popin()
	var data = current_dialogue[current_line_number]
	#Если значение словаря String, печать текста
	if typeof(data) == 4:
		#Обработка строки словаря для отделения текста от служебной информации и
		#передача текста в печать 
		await dialogue_box.text_typing(await parse_line(data))
		current_line_number = current_line_number + 1
	#Если значение словаря Array, визуализация кнопок с опциями
	elif typeof(data) == 28:
		await dialogue_box.fill_options(data)
		current_line_number = current_line_number + 1


func parse_line(line : String) -> String:
	var line_info = line.split(":")
	if line_info[0] == "Player":
		Globals.player.on_player_avatar_called()
		#Signals.emit_signal("player_avatar_called")
	elif line_info[0] == "Npc":
		Globals.player.on_npc_avatar_called()
		#Signals.emit_signal("npc_avatar_called")
	return line_info[1]
