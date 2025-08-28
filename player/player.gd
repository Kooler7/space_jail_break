#player.gd
class_name Player

extends Node2D

enum PlayerStates {
	EXPLANING,
	TALKING,
	INTERRACTING,
	IDLE
}
var current_player_state : PlayerStates = PlayerStates.IDLE

var npc_data : Dictionary = {}
var current_dialogue : Dictionary = {}
var current_line : int = 1


@onready var gui : Control = $GUI
@onready var person : Sprite2D = $Person
@onready var options_pool : VBoxContainer = $GUI/Buttons
@onready var animation : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Signals.game_object_became_explane.connect(check_player_states.bind(PlayerStates.EXPLANING))
	Signals.game_object_became_idle.connect(check_player_states.bind(PlayerStates.IDLE))
	Signals.npc_became_talk.connect(check_player_states.bind(PlayerStates.TALKING))
	
	Signals.dialogue_box_clicked.connect(on_dialogue_box_clicked)



func set_current_state(transfered_data : Dictionary, new_state : PlayerStates) -> void:
	#Выход из текущего состояния
	#Вход в новое состояние
	#Действия в новом состоянии
	pass

##Переключение состояний взаимодействия с объектами
func check_player_states(transfered_data : Dictionary, new_state : PlayerStates) -> void:
	match new_state:
		#Перевод в режим отображения экплейнера и его отображение
		PlayerStates.EXPLANING:
			#region
			if current_player_state == PlayerStates.IDLE:
				gui.explaner_popin()
				gui.explaner.text = transfered_data["name"]
				current_player_state = PlayerStates.EXPLANING
			#endregion
		#Перевод в режим взаимодействия
		PlayerStates.INTERRACTING:
			pass
		PlayerStates.TALKING:
			#region
			if current_player_state == PlayerStates.EXPLANING:
				current_dialogue = transfered_data
				await gui.explaner_popout()
				await gui.dialogue_box_popin()
				parse_dialogue()
				current_player_state = PlayerStates.TALKING
				gui.mouse_filter = Control.MOUSE_FILTER_STOP
			#endregion
		PlayerStates.IDLE:
			#region
			if current_player_state == PlayerStates.EXPLANING:
				gui.explaner_popout()
			elif current_player_state == PlayerStates.TALKING:
				gui.dialogue_box_popout()
			current_player_state = PlayerStates.IDLE
			gui.mouse_filter = Control.MOUSE_FILTER_IGNORE
			#endregion


##Обработка сигнала "dialogue_box_clicked"
func on_dialogue_box_clicked() -> void:
	#Проверка номера строки не больше размера диалога
	if current_line <= current_dialogue.size():
		#Запуск обработки диалога
		parse_dialogue()
	else:
		#Запуск сигнала об окончании диалога и сброс текстового поля до нуля и
		#присвоение номера строки "по умолчанию"
		current_line = 1
		Signals.emit_signal("dialogue_completed")
		gui.dialogue_text.visible_ratio = 0
	pass

##Обработка словаря диалога
func parse_dialogue() -> void:
	var data = current_dialogue[current_line]
	#Если значение словаря String, печать текста
	if typeof(data) == 4:
		#Сброс видимости текста в текстовом поле до нуля
		gui.dialogue_text.visible_ratio = 0
		#Обработка строки словаря для отделения текста от служебной информации и
		#передача текста в печать 
		await gui.text_type(await parse_line(data))
		
		current_line = current_line + 1
		gui.dialogue_box.mouse_filter = Control.MOUSE_FILTER_STOP
	elif typeof(data) == 28:
		gui.dialogue_text.visible_ratio = 0
		for item in data:
			var option : PackedScene = load(item)
			var child : Button = option.instantiate()
			options_pool.add_child(child)
			child.pressed.connect(on_option_pressed.bind(child))
			gui.dialogue_box.mouse_filter = Control.MOUSE_FILTER_IGNORE


func parse_line(line : String) -> String:
	var line_info = line.split(":")
	if line_info[0] == "Player":
		animation.play("avatar_popup")
		await animation.animation_finished
	elif line_info[0] == "Npc":
		if person.modulate != Color(1, 1, 1, 0): 
			animation.play_backwards("avatar_popup")
			await animation.animation_finished
	return line_info[1]




func on_option_pressed(option : Button) -> void:
	if option.name == "Leave":
		current_line = 1
		Signals.emit_signal("dialogue_completed")
	else:
		var name : String = option.name
		current_line = int(name)
		parse_dialogue()
	var option_buttons = options_pool.get_children()
	for button in option_buttons:
		button.queue_free()
