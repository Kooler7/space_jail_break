class_name Player

extends Node2D

@onready var gui : Control = $GUI
@onready var person : Sprite2D = $Person

func _ready() -> void:
	Signals.game_object_mouse_entered.connect(check_player_states.bind(PlayerStates.EXPLANER_SHOWING))
	Signals.game_object_mouse_exited.connect(check_player_states.bind(PlayerStates.EXPLANER_HIDING))
	Signals.npc_mouse_clicked.connect(check_player_states.bind(PlayerStates.DIALOGUE_SHOWING))
	Signals.dialogue_box_clicked.connect(check_player_states.bind(PlayerStates.DIALOGUE_HIDING))

enum PlayerStates {
	EXPLANER_SHOWING,
	EXPLANER_HIDING,
	INTERRACTING,
	DIALOGUE_SHOWING,
	DIALOGUE_HIDING,
	IDLE
}
var current_player_state : PlayerStates = PlayerStates.IDLE



func check_player_states(transfered_data : Dictionary, new_state : PlayerStates) -> void:
	match new_state:
		PlayerStates.EXPLANER_SHOWING:
			if current_player_state == PlayerStates.IDLE:
				gui.explaner_popin()
				gui.explaner.text = transfered_data["name"]
				current_player_state = PlayerStates.EXPLANER_SHOWING
		PlayerStates.EXPLANER_HIDING:
			if current_player_state == PlayerStates.EXPLANER_SHOWING:
				gui.explaner_popout()
				current_player_state = PlayerStates.IDLE
		PlayerStates.INTERRACTING:
			pass
		PlayerStates.DIALOGUE_SHOWING:
			if current_player_state == PlayerStates.EXPLANER_SHOWING:
				gui.dialogue_text.text = transfered_data["dialogue_text"]
				gui.dialogue_box_popin()
				current_player_state = PlayerStates.DIALOGUE_SHOWING
		PlayerStates.DIALOGUE_HIDING:
			if current_player_state == PlayerStates.DIALOGUE_SHOWING:
				gui.dialogue_text.text = transfered_data["dialogue_text"]
				await gui.dialogue_box_popout()
				current_player_state = PlayerStates.EXPLANER_SHOWING
				check_player_states(gui.trancfered_data_eraser, PlayerStates.EXPLANER_HIDING)
		PlayerStates.IDLE:
			current_player_state = PlayerStates.IDLE



func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
