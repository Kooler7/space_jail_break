class_name Player

extends Node2D

@onready var gui : Control = $GUI
@onready var person : Sprite2D = $Person

func _ready() -> void:
	Signals.test_npc_mouse_entered.connect(check_player_states.bind(PlayerStates.EXPLANING))
	Signals.test_npc_mouse_exited.connect(gui.check_gui_state.bind(gui.InterfaceStates.IDLE))

enum PlayerStates {
	EXPLANING,
	INTERRACTING,
	TALKING,
}




func check_player_states(new_state : PlayerStates) -> void:
	match new_state:
		PlayerStates.EXPLANING:
			gui.check_gui_state(gui.InterfaceStates.EXPLANING)
		PlayerStates.INTERRACTING:
			pass
		PlayerStates.TALKING:
			pass
