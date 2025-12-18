extends Node

const END_DIALOGUE_NODE = "END"
const START_DIALOGUE_NODE = "N1"


var dialogue_ui : DialogueUI = null

var _current_dialogue_tree : DialogueTree = null
var _current_dialogue_node : DialogueNode = null
var _current_dialogue_option : DialogueOption = null
var _option_callable : Callable


##Публичные функции
#region
##Функция загрузки дерева диалога
func set_dialogue_tree(new_tree : DialogueTree) -> void:
	if new_tree and _current_dialogue_tree != new_tree:
		_current_dialogue_tree = new_tree
	else:
		return

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
		check_node_type()
	elif _current_dialogue_tree == null:
		return

#endregion




##Обработка сигнала "on_option_clicked"
func _on_option_clicked(option : DialogueOption) -> void:
	_current_dialogue_option = option
	dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
		dialogue_box.VisibilityStates.REMOVE_OPTIONS)
	_option_callable = _current_dialogue_option.option_action
	_option_callable.call()
	_current_dialogue_option = null
	

##Обработка сигнала "dialogue_box_clicked"
func change_dialogue_node() -> void:
	#Проверка номера строки не больше размера диалога
	if _current_dialogue_node.next_node != "END":
		_current_dialogue_node = _current_dialogue_tree.\
			get_node_safe(_current_dialogue_node.next_node)
		check_node_type()
	elif _current_dialogue_node.next_node == "END":
		finish_dialogue()
		




##Заканчивание диалога
func finish_dialogue() -> void:
	dialogue_ui.dialogue_box.text_field.text = ""
	await  dialogue_ui.toggle_speaker_avatar("", true)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
		dialogue_box.VisibilityStates.POP_OUT)
	await Globals.get_player().update_level_state(Player.\
		PlayerLevelStates.IN_WORLD)
	Globals.get_current_object().mouse_detector.input_pickable = true
	_current_dialogue_node = null
	_current_dialogue_tree = null
	_current_dialogue_option = null
	Globals.current_object = null



##Проверка типа узла диалога
func check_node_type() -> void:
	match _current_dialogue_node.current_node_type:
		_current_dialogue_node.NodeTypes.RANDOMIZER:
			execute_randomizer()
		_current_dialogue_node.NodeTypes.TEXT:
			execute_text()
		_current_dialogue_node.NodeTypes.OPTIONS:
			execute_options()
		_current_dialogue_node.NodeTypes.ACTION:
			execute_action()


##Обработка узла типа "Рандомайзер"
func execute_randomizer() -> void:
	var picked_next_node = _current_dialogue_node.random_nodes.pick_random()
	_current_dialogue_node = _current_dialogue_tree.\
		get_node_safe(picked_next_node)
	check_node_type()


##Обработка узла типа "Текст"
func execute_text() -> void:
	var temp_text_translation = tr(_current_dialogue_node.node_text)
	dialogue_ui.toggle_speaker_avatar(_current_dialogue_node.speaker)
	dialogue_ui.set_text(temp_text_translation)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
		dialogue_box.VisibilityStates.POP_IN)
	await dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
		dialogue_box.VisibilityStates.Fill_TEXT)



##Обработка узла типа "Опции"
func execute_options() -> void:
	dialogue_ui.dialogue_box.options = _current_dialogue_node.options
	dialogue_ui.dialogue_box.update_visibility_state(dialogue_ui.\
		dialogue_box.VisibilityStates.FILL_OPTIONS)


#Обработка узла типа "Действия"
func execute_action() -> void:
	match _current_dialogue_node.current_action_type:
		
		_current_dialogue_node.ActionTypes.SET_LEVEL_FLAG:
			for flag in _current_dialogue_node.flags:
				_set_level_global_flag(GameState.level_flags, flag.key,\
					flag.value)
		
		_current_dialogue_node.ActionTypes.SET_ITEM:
			for item in _current_dialogue_node.items:
				_set_remove_item(item)
		
		_current_dialogue_node.ActionTypes.SET_GLOBAL_FLAG:
			for flag in _current_dialogue_node.flags:
				_set_level_global_flag(GameState.global_flags, flag.key,\
					 flag.value)
		
		_current_dialogue_node.ActionTypes.REMOVE_ITEM:
			for item in _current_dialogue_node.items:
				_set_remove_item(item)

		_current_dialogue_node.ActionTypes.CHANGE_DIALOGUE_TREE:
			_current_dialogue_tree = Globals.current_object.\
				check_available_dialogue_tree()
			if _current_dialogue_tree != null:
				_current_dialogue_node = _current_dialogue_tree.\
					get_node_safe(START_DIALOGUE_NODE)
			elif _current_dialogue_tree == null:
				return

	change_dialogue_node()


#Функция установки или удаления элемента в инвентаре
func _set_remove_item(item: String) -> void:
	if GameState.has_item(item) == false:
		GameState.add_item(item)
	elif GameState.has_item(item) == true:
		GameState.remove_item(item)

#Фукция установки значения этапа уровня или глобального этапа
func _set_level_global_flag(new_storage: Dictionary, new_flag: String,\
	 new_value: bool) -> void:
	if GameState.has_flag(new_storage, new_flag):
		GameState.set_flag(new_storage, new_flag, new_value)
	else:
		return
