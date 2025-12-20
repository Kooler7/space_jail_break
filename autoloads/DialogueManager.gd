extends Node

const END_DIALOGUE_NODE = "END"
const START_DIALOGUE_NODE = "N1"


var dialogue_ui : DialogueUI = Globals.get_dialogue_ui()

var _current_dialogue_tree : DialogueTree = null
var _current_dialogue_node : DialogueNode = null




##Публичные функции
#region
##Функция загрузки дерева диалога
func set_dialogue_tree() -> void:
	_current_dialogue_tree = Globals.get_current_object().\
												check_available_dialogue_tree()

##Функция получения дерева диалога
func get_dialogue_tree() -> DialogueTree:
	if _current_dialogue_tree != null:
		return _current_dialogue_tree
	return 

##Обработка словаря диалога
func start_dialogue() -> void:
	if _current_dialogue_tree != null:
		#Подготовка к вызову окна диалога
		Globals.get_player().update_level_state(Player.\
												PlayerLevelStates.IN_DIALOGUE)
		Globals.get_current_object().set_mouse_detector_pickability(false)
		_current_dialogue_node = _current_dialogue_tree.\
											get_node_safe(START_DIALOGUE_NODE)
		#Вызов обработки текущей реплики
		_check_node_type()
	elif _current_dialogue_tree == null:
		return

##Обработка сигнала "on_option_clicked"
func on_option_made(option : DialogueOption) -> void:
	dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
								dialogue_box.VisibilityStates.REMOVE_OPTIONS)
	_current_dialogue_node.next_node = option.next_dialogue_node_name
	change_dialogue_node()

##Обработка сигнала "dialogue_box_clicked"
func change_dialogue_node() -> void:
	if _current_dialogue_tree != null:
		#Проверка номера строки не больше размера диалога
		if _current_dialogue_node.next_node != END_DIALOGUE_NODE:
			_current_dialogue_node = _current_dialogue_tree.\
								get_node_safe(_current_dialogue_node.next_node)
			_check_node_type()
		elif _current_dialogue_node.next_node == END_DIALOGUE_NODE:
			_finish_dialogue()
	elif _current_dialogue_tree == null:
		return
#endregion



##Заканчивание диалога
func _finish_dialogue() -> void:
	dialogue_ui.dialogue_box.text_field.text = ""
	await dialogue_ui.toggle_speaker_avatar("", true)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
										dialogue_box.VisibilityStates.POP_OUT)
	await Globals.get_player().update_level_state(Player.\
													PlayerLevelStates.IN_WORLD)
	Globals.get_current_object().mouse_detector.input_pickable = true
	_current_dialogue_node = null
	_current_dialogue_tree = null
	Globals.set_current_object(null)


##Проверка типа узла диалога
func _check_node_type() -> void:
	match _current_dialogue_node.current_node_type:
		_current_dialogue_node.NodeTypes.TEXT:
			_execute_text()
		_current_dialogue_node.NodeTypes.OPTIONS:
			_execute_options()
		_current_dialogue_node.NodeTypes.ACTION:
			_execute_action()


##Обработка узла типа "Текст"
func _execute_text() -> void:
	var temp_text_translation = tr(_current_dialogue_node.node_text)
	dialogue_ui.toggle_speaker_avatar(_current_dialogue_node.speaker)
	dialogue_ui.set_text(temp_text_translation)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
											dialogue_box.VisibilityStates.POP_IN)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
										dialogue_box.VisibilityStates.Fill_TEXT)


##Обработка узла типа "Опции"
func _execute_options() -> void:
	dialogue_ui.dialogue_box.options = _current_dialogue_node.options
	dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
									dialogue_box.VisibilityStates.FILL_OPTIONS)


#Обработка узла типа "Действия"
func _execute_action() -> void:
	match _current_dialogue_node.current_action_type:
		
		_current_dialogue_node.ActionTypes.RANDOMIZER:
			_execute_randomizer()
		
		_current_dialogue_node.ActionTypes.SET_LEVEL_FLAG:
			for flag in _current_dialogue_node.flags:
				_set_level_or_global_flag(GameState.level_flags, flag.key,\
																	flag.value)
		
		_current_dialogue_node.ActionTypes.SET_ITEM:
			for item in _current_dialogue_node.items:
				_set_remove_item(item)
		
		_current_dialogue_node.ActionTypes.SET_GLOBAL_FLAG:
			for flag in _current_dialogue_node.flags:
				_set_level_or_global_flag(GameState.global_flags, flag.key,\
																	 flag.value)
		
		_current_dialogue_node.ActionTypes.REMOVE_ITEM:
			for item in _current_dialogue_node.items:
				_set_remove_item(item)

		_current_dialogue_node.ActionTypes.CHANGE_DIALOGUE_TREE:
			set_dialogue_tree()

	change_dialogue_node()

##Функция обработки action типа "Рандомайзер"
func _execute_randomizer() -> void:
	var picked_next_node = _current_dialogue_node.random_nodes.pick_random()
	_current_dialogue_node.next_node = picked_next_node



##Функция установки или удаления элемента в инвентаре
func _set_remove_item(item: String) -> void:
	if GameState.has_item(item) == false:
		GameState.add_item(item)
	elif GameState.has_item(item) == true:
		GameState.remove_item(item)

##Фукция установки значения этапа уровня или глобального этапа
func _set_level_or_global_flag(new_storage: Dictionary, new_flag: String,\
	 													new_value: bool) -> void:
	if GameState.has_flag(new_storage, new_flag):
		GameState.set_flag(new_storage, new_flag, new_value)
	else:
		return
