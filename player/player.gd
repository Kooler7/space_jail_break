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

#var npc_data : Dictionary = {}
#var current_dialogue : Dictionary = {}
#var current_line : int = 1
var current_game_object : Node2D

@onready var gui : Control = $GUI
@onready var avatar : Sprite2D = $Avatar
@onready var dialogue_manager : Node = $DialogueManager
@onready var game_object_holder : Node2D = $GameObject


func _ready() -> void:
	Signals.game_object_clicked.connect(on_game_object_clicked)
	#Signals.game_object_became_explane.connect(check_player_states.bind(PlayerStates.EXPLANING))
	#Signals.game_object_became_idle.connect(check_player_states.bind(PlayerStates.IDLE))
	#Signals.npc_became_talk.connect(check_player_states.bind(PlayerStates.TALKING))
	#Signals.player_avatar_called.connect()
	pass


func on_game_object_clicked(scene : PackedScene) -> void:
	var new_scene : Node2D = scene.instantiate()
	game_object_holder.add_child(new_scene)
	current_game_object = game_object_holder.get_child(0)


#func on_player_avatar_called() -> void:
	#pass

##Переключение состояний взаимодействия с объектами
#func check_player_states(transfered_data : Dictionary, new_state : PlayerStates) -> void:
	#match new_state:
		##Перевод в режим отображения экплейнера и его отображение
		#PlayerStates.EXPLANING:
			##region
			#if current_player_state == PlayerStates.IDLE:
				#gui.explaner_popin()
				#gui.explaner.text = transfered_data["name"]
				#current_player_state = PlayerStates.EXPLANING
			##endregion
		##Перевод в режим взаимодействия
		#PlayerStates.INTERRACTING:
			#pass
		#PlayerStates.TALKING:
			##region
			#if current_player_state == PlayerStates.EXPLANING:
				#gui.explaner_popout()
				#dialogue_manager.current_dialogue = transfered_data
				#dialogue_manager.parse_dialogue()
				#current_player_state = PlayerStates.TALKING
				#gui.mouse_filter = Control.MOUSE_FILTER_STOP
			##endregion
		#PlayerStates.IDLE:
			##region
			#if current_player_state == PlayerStates.EXPLANING:
				#gui.explaner_popout()
			#current_player_state = PlayerStates.IDLE
			#gui.mouse_filter = Control.MOUSE_FILTER_IGNORE
			##endregion
