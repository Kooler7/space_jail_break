extends Node

const END_DIALOGUE_NUMBER = -1
const START_DIALOGUE_NUMBER = 1

var current_dialogue : Dictionary
var current_line : Dictionary
var current_line_number : int = 1


##Обработка сигнала "dialogue_box_clicked"
func on_dialogue_box_clicked() -> void:
	#Проверка номера строки не больше размера диалога
	if current_line_number != END_DIALOGUE_NUMBER:
		#Запуск обработки диалога
		parse_line_type()
	elif current_line_number == END_DIALOGUE_NUMBER:
		#Запуск сигнала об окончании диалога и сброс текстового поля до нуля и
		#присвоение номера строки "по умолчанию"
		current_line_number = START_DIALOGUE_NUMBER
		if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
			Globals.player.on_dialogue_completed()
			Globals.current_object.on_dialogue_completed()
			Globals.current_object = null
		elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
			Globals.player.on_dialogue_completed()
			Globals.current_object.on_dialogue_completed()
			Globals.current_object = null
		

##Обработка словаря диалога
func start_dialogue() -> void:
	
	#Включение фильтра кликов игрока
	Globals.player.mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	
	#Вызов окна диалога
	await Globals.player.on_dialogue_started()
	
	#Проверка рандомного старта и назначение текущей реплики
	if current_dialogue["is_random_start"] == true:
		var ranges : Array = current_dialogue["random_range"]
		var first : int = ranges[0]
		var last : int = ranges[1]
		var number = randi_range(first, last)
		current_line = current_dialogue["Line_" + str(number)]
	elif current_dialogue["is_random_start"] == false:
		current_line_number = START_DIALOGUE_NUMBER
		current_line = current_dialogue["Line_" + str(current_line_number)]
	
	#Вызов обработки текущей реплики
	parse_line_type()


##Обработка текущей реплики
func parse_line_type() -> void:
	#Проверка типа реплики
	if current_line["Type"] == "Text":
		parse_dialogue_line()
	elif current_line["Type"] == "Options":
		parse_options_line()

func parse_dialogue_line() -> void:
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
		match current_line["Character"]:
			"Player":
				await Globals.current_object.on_npc_avatar_dismissed()
				await Globals.player.on_player_avatar_called()
			"Npc":
				pass
	elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
		await Globals.player.on_player_avatar_called()
	await Globals.player.dialogue_box.text_typing(current_line["Words"])
	current_line_number = current_line["Next_line"]


func parse_options_line() -> void:
	pass

#func parse_line(line : String) -> String:
	#var line_info = line.split(":")
	#if line_info[0] == "Player":
		#Globals.player.on_player_avatar_called()
		##Signals.emit_signal("player_avatar_called")
	#elif line_info[0] == "Npc":
		#Globals.player.on_npc_avatar_called()
		##Signals.emit_signal("npc_avatar_called")
	#return line_info[1]
