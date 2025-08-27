#player.gd
class_name Player

extends Node2D

enum PlayerStates {
	EXPLANING,
	EXPLANER_HIDING,
	INTERRACTING,
	DIALOGUE_SHOWING,
	DIALOGUE_HIDING,
	IDLE
}
var current_player_state : PlayerStates = PlayerStates.IDLE



@onready var gui : Control = $GUI
@onready var person : Sprite2D = $Person

func _ready() -> void:
	Signals.game_object_mouse_entered.connect(check_player_states.bind(PlayerStates.EXPLANING))
	Signals.game_object_mouse_exited.connect(check_player_states.bind(PlayerStates.EXPLANER_HIDING))
	Signals.npc_mouse_clicked.connect(check_player_states.bind(PlayerStates.DIALOGUE_SHOWING))
	Signals.dialogue_box_clicked.connect(check_player_states.bind(PlayerStates.DIALOGUE_HIDING))


func set_current_state(new_state : PlayerStates) -> void:
	#Выход из текущего состояния
	#Вход в новое состояние
	#Действия в новом состоянии


func check_player_states(transfered_data : Dictionary, new_state : PlayerStates) -> void:
	match new_state:
		#Перевод в режим отображения экплейнера и его отображение
		PlayerStates.EXPLANING:
			#Переход возможен только из режима бездействия
			if current_player_state == PlayerStates.IDLE:
				gui.check_gui_states(gui.GuiStates.EXPLANER_SHOWING)
				gui.explaner.text = transfered_data["name"]
				current_player_state = PlayerStates.EXPLANING
		#Скрытие эксплейнера и перевод в режим бездействия
		PlayerStates.EXPLANER_HIDING:
			if current_player_state == PlayerStates.EXPLANING:
				gui.explaner_popout()
				current_player_state = PlayerStates.IDLE
		#Перевод в режим взаимодействия
		PlayerStates.INTERRACTING:
			pass
		PlayerStates.DIALOGUE_SHOWING:
			if current_player_state == PlayerStates.EXPLANING:
				gui.dialogue_text.text = transfered_data["dialogue_text"]
				gui.dialogue_box_popin()
				current_player_state = PlayerStates.DIALOGUE_SHOWING
		PlayerStates.DIALOGUE_HIDING:
			if current_player_state == PlayerStates.DIALOGUE_SHOWING:
				gui.dialogue_text.text = transfered_data["dialogue_text"]
				await gui.dialogue_box_popout()
				current_player_state = PlayerStates.EXPLANING
				check_player_states(gui.trancfered_data_eraser, PlayerStates.EXPLANER_HIDING)
		PlayerStates.IDLE:
			if current_player_state == PlayerStates.EXPLANING:
				gui.check_gui_states(gui.GuiStates.EXPLANER_HIDING)
			current_player_state = PlayerStates.IDLE
