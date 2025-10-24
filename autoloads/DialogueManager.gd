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
	if current_dialogue.is_empty() == false:
		#Подготовка к вызову окна диалога
		if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
			Globals.player.current_npc_avatar = Globals.current_object.avatar
			Globals.current_object.toggle_pickable()
		elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
			Globals.current_object.toggle_pickable()
		current_line_number = START_DIALOGUE_NUMBER
		current_line = current_dialogue["Line_" + str(current_line_number)]
		
		#Вызов обработки текущей реплики
		parse_line_type()
	elif current_dialogue.is_empty() == true:
		return


##Заканчивание диалога
func finish_dialogue() -> void:
	current_line_number = START_DIALOGUE_NUMBER
	await Globals.player.update_action_state(Globals.player.LevelActionStates.IDLE)
	Globals.current_object.toggle_pickable()


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
		"Exicute":
			parse_exicute_line()

##Обработка реплики с действием
func parse_exicute_line() -> void:
	match current_line["Method"]:
		"update_player_decisions":
			update_player_decisions(current_line["Decision"], current_line["Value"])
	current_line_number = current_line["Next_line"]
	on_dialogue_box_clicked()


func update_player_decisions(decision : String, value : bool) -> void:
	Globals.player.player_chapter_decisions[decision] = value



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
	var temp_text_translation = await tr(current_line["Words"])
	Globals.player.action_text = temp_text_translation
	if Globals.current_object.object_type == Globals.current_object.ObjectTypes.NPC:
		match current_line["Character"]:
			"Player":
				await Globals.player.update_action_state(Globals.player.LevelActionStates.SPEAK)
			"Npc":
				await Globals.player.update_action_state(Globals.player.LevelActionStates.LISTEN)
	elif Globals.current_object.object_type == Globals.current_object.ObjectTypes.ENVIRONMENT:
		await Globals.player.update_action_state(Globals.player.LevelActionStates.SPEAK)
	current_line_number = current_line["Next_line"]
	


##Обработка реплики типа "Опции"
func parse_options_line(paths : Array) -> void:
	Globals.player.choosing_options = paths
	await Globals.player.update_action_state(Globals.player.LevelActionStates.SPEAK)
	await Globals.player.update_action_state(Globals.player.LevelActionStates.CHOOSE)
