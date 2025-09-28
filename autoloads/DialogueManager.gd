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
		current_line = current_dialogue["Line_" + str(current_line_number)]
		#Запуск обработки диалога
		parse_line_type()
	elif current_line_number == END_DIALOGUE_NUMBER:
		finish_dialogue()
		

##Обработка словаря диалога
func start_dialogue() -> void:
	#Вызов окна диалога
	await Globals.current_object.on_dialogue_started()
	await Globals.player.on_dialogue_started()
	
	current_line_number = START_DIALOGUE_NUMBER
	current_line = current_dialogue["Line_" + str(current_line_number)]
	
	#Вызов обработки текущей реплики
	parse_line_type()

func finish_dialogue() -> void:
	current_line_number = START_DIALOGUE_NUMBER
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
		Globals.player.on_dialogue_completed()
		Globals.current_object.on_dialogue_completed()
		#Globals.current_object = null
	elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
		Globals.player.on_dialogue_completed()
		Globals.current_object.on_dialogue_completed()
		#Globals.current_object = null




##Обработка текущей реплики
func parse_line_type() -> void:
	#Проверка типа реплики
	match current_line["Type"]:
		"Text":
			parse_dialogue_line()
		"Options":
			parse_options_line(current_line["Paths"])
		"Random":
			parse_random_line()

###Обработка реплики типа "Рандом"
func parse_random_line() -> void:
	var ranges : Array = current_line["Random_range"]
	var first : int = ranges[0]
	var last : int = ranges[1]
	var number = randi_range(first, last)
	current_line = current_dialogue["Line_" + str(number)]
	parse_line_type()

##Обработка реплики типа "Тескт"
func parse_dialogue_line() -> void:
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
		match current_line["Character"]:
			"Player":
				await Globals.current_object.on_npc_avatar_dismissed()
				await Globals.player.on_player_avatar_called()
			"Npc":
				await Globals.player.on_player_avatar_dismissed()
				await Globals.current_object.on_nps_avatar_called()
	elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
		await Globals.player.on_player_avatar_called()
	await Globals.player.dialogue_box.text_typing(current_line["Words"])
	current_line_number = current_line["Next_line"]
	


##Обработка реплики типа "Опции"
func parse_options_line(paths : Array) -> void:
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
			await Globals.current_object.on_npc_avatar_dismissed()
			await Globals.player.on_player_avatar_called()
			await Globals.player.dialogue_box.fill_options(paths)
	elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
		await Globals.player.dialogue_box.fill_options(paths)

#func parse_line(line : String) -> String:
	#var line_info = line.split(":")
	#if line_info[0] == "Player":
		#Globals.player.on_player_avatar_called()
		##Signals.emit_signal("player_avatar_called")
	#elif line_info[0] == "Npc":
		#Globals.player.on_npc_avatar_called()
		##Signals.emit_signal("npc_avatar_called")
	#return line_info[1]
