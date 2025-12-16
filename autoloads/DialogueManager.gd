extends Node

const END_DIALOGUE_NODE = "END"
const START_DIALOGUE_NODE = "N1"


var dialogue_ui : DialogueUI = null

var current_dialogue_tree : DialogueTree = null
var current_dialogue_node : DialogueNode = null
var current_dialogue_option : DialogueOption = null
var option_callable : Callable

##Обработка сигнала "on_option_clicked"
func _on_option_clicked(option : DialogueOption) -> void:
	current_dialogue_option = option
	dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.dialogue_box.VisibilityStates.REMOVE_OPTIONS)
	option_callable = current_dialogue_option.option_action
	option_callable.call()
	current_dialogue_option = null
	

##Обработка сигнала "dialogue_box_clicked"
func on_dialogue_box_clicked(tree : DialogueTree) -> void:
	#Проверка номера строки не больше размера диалога
	if current_dialogue_node.next_node != "END":
		current_dialogue_node = tree.get_node_safe(current_dialogue_node.next_node)
		check_node_type()
	elif current_dialogue_node.next_node == "END":
		finish_dialogue()
		

##Обработка словаря диалога
func start_dialogue() -> void:
	if current_dialogue_tree != null:
		#Подготовка к вызову окна диалога
		Globals.player.update_level_state(Player.PlayerLevelStates.IN_DIALOGUE)
		Globals.current_object.mouse_detector.input_pickable = false
		print(Globals.current_object.mouse_detector.input_pickable)
		current_dialogue_node = current_dialogue_tree.get_node_safe(START_DIALOGUE_NODE)
		#Вызов обработки текущей реплики
		check_node_type()
	elif current_dialogue_tree == null:
		return


##Заканчивание диалога
func finish_dialogue() -> void:
	dialogue_ui.dialogue_box.text_field.text = ""
	await  dialogue_ui.toggle_speaker_avatar("", true)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.dialogue_box.VisibilityStates.POP_OUT)
	await Globals.player.update_level_state(Player.PlayerLevelStates.IN_WORLD)
	Globals.current_object.mouse_detector.input_pickable = true
	print(Globals.current_object.mouse_detector.input_pickable)
	current_dialogue_node = null
	current_dialogue_tree = null
	current_dialogue_option = null
	Globals.current_object = null



##Проверка типа узла диалога
func check_node_type() -> void:
	match current_dialogue_node.current_node_type:
		current_dialogue_node.NodeTypes.RANDOMIZER:
			execute_randomizer()
		current_dialogue_node.NodeTypes.TEXT:
			execute_text()
		current_dialogue_node.NodeTypes.OPTIONS:
			execute_options()
		current_dialogue_node.NodeTypes.ACTION:
			execute_action()


##Обработка узла типа "Рандомайзер"
func execute_randomizer() -> void:
	var picked_next_node = current_dialogue_node.random_nodes.pick_random()
	current_dialogue_node = current_dialogue_tree.get_node_safe(picked_next_node)
	check_node_type()


##Обработка узла типа "Текст"
func execute_text() -> void:
	var temp_text_translation = tr(current_dialogue_node.node_text)
	dialogue_ui.toggle_speaker_avatar(current_dialogue_node.speaker)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.dialogue_box.VisibilityStates.POP_IN)
	await dialogue_ui.dialogue_box.text_typing(temp_text_translation)



##Обработка узла типа "Опции"
func execute_options() -> void:
	dialogue_ui.dialogue_box.options = current_dialogue_node.options
	dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.dialogue_box.VisibilityStates.FILL_OPTIONS)


#Обработка узла типа "Действия"
func execute_action() -> void:
	match current_dialogue_node.current_action_type:
		
		current_dialogue_node.ActionTypes.SET_LEVEL_FLAG:
			for flag in current_dialogue_node.flags:
				set_level_global_flag(GameState.level_flags, flag.key, flag.value)
		
		current_dialogue_node.ActionTypes.SET_ITEM:
			for item in current_dialogue_node.items:
				set_remove_item(item)
		
		current_dialogue_node.ActionTypes.SET_GLOBAL_FLAG:
			for flag in current_dialogue_node.flags:
				set_level_global_flag(GameState.global_flags, flag.key, flag.value)
		
		current_dialogue_node.ActionTypes.REMOVE_ITEM:
			for item in current_dialogue_node.items:
				set_remove_item(item)

		current_dialogue_node.ActionTypes.CHANGE_DIALOGUE_TREE:
			current_dialogue_tree = Globals.current_object.check_available_dialogue_tree()
			if current_dialogue_tree != null:
				current_dialogue_node = current_dialogue_tree.get_node_safe(START_DIALOGUE_NODE)
			elif current_dialogue_tree == null:
				return

	on_dialogue_box_clicked(current_dialogue_tree)


#Функция установки или удаления элемента в инвентаре
func set_remove_item(item: String) -> void:
	if GameState.has_item(item) == false:
		GameState.add_item(item)
	elif GameState.has_item(item) == true:
		GameState.remove_item(item)

#Фукция установки значения этапа уровня или глобального этапа
func set_level_global_flag(new_storage: Dictionary, new_flag: String, new_value: bool) -> void:
	if GameState.has_flag(new_storage, new_flag):
		GameState.set_flag(new_storage, new_flag, new_value)
	else:
		return
