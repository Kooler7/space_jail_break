#dialogue_manager.gd
extends Node


var current_dialogue : Dictionary = {}
var current_line_number : int = 1

@onready var dialogue_box : TextureRect = $DialogueBox

func _ready() -> void:
	Signals.dialogue_box_clicked.connect(on_dialogue_box_clicked)
	Signals.leave_option_clicked.connect(on_leave_option_clicked)
	Signals.new_line_requested.connect(parse_dialogue)

func on_leave_option_clicked() -> void:
	current_line_number = 1
	dialogue_box.dialogue_box_popout()
	Signals.emit_signal("dialogue_completed")


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
		Signals.emit_signal("dialogue_completed")

	pass

func parse_dialogue(line_number : int = current_line_number) -> void:
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
		Signals.emit_signal("player_avatar_called")
	elif line_info[0] == "Npc":
		Signals.emit_signal("npc_avatar_called")
	return line_info[1]
