extends Node

const END_DIALOGUE_NODE = "END"
const START_DIALOGUE_NODE = "N1"

var dialogue_ui : DialogueUI = null

var current_dialogue_tree : DialogueTree = null
var current_dialogue_node : DialogueNode = null

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
		Globals.current_object.toggle_pickable()
		current_dialogue_node = current_dialogue_tree.get_node_safe(START_DIALOGUE_NODE)
		Globals.player.update_level_state(Player.PlayerLevelStates.IN_DIALOGUE)
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
	Globals.current_object.toggle_pickable()



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
	var options = current_dialogue_node.options


#Обработка узла типа "Действия"
func execute_action() -> void:
	pass
