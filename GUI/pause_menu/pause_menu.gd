extends ColorRect

#const START_MODULATE : Color = Color(1, 1, 1, 0)
#const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
#const MODULATION_TIME : float = 0.1
#const START_RATIO : int = 0
#const FINISH_RATIO : int = 1
#const LETTER_SPEED : float = 0.02

const ModulateGray = Color(0, 0, 0, 0.5)
const ModulateDefault = Color(0, 0, 0, 0)


enum PauseMenuStates {
	ACTIVE,
	INACTIVE
}
@export var current_menu_state : PauseMenuStates = PauseMenuStates.ACTIVE

@onready var paper : AnimatedSprite2D = $AnimatedSprite2D
@onready var stamp_sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var accept_button : TextureButton = $AcceptButton
@onready var deny_button : TextureButton = $DenyButton
@onready var text : Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_menu_state(PauseMenuStates.INACTIVE)



func update_menu_state(new_state : PauseMenuStates) -> void:
	if new_state != current_menu_state:
		match  new_state:
			PauseMenuStates.ACTIVE:
				self_modulate = ModulateGray
				accept_button.disabled = false
				deny_button.disabled = false
				show()
				paper.play("default")
				await paper.animation_finished
				accept_button.show()
				deny_button.show()
				text.show()
				current_menu_state = PauseMenuStates.ACTIVE
				return
			PauseMenuStates.INACTIVE:
				accept_button.disabled = true
				deny_button.disabled = true
				accept_button.hide()
				deny_button.hide()
				accept_button.button_pressed = false
				deny_button.button_pressed = false
				text.hide()
				paper.play_backwards("default")
				await paper.animation_finished
				hide()
				self_modulate = ModulateDefault
				current_menu_state = PauseMenuStates.INACTIVE
				return





func _on_accept_button_button_up() -> void:
	stamp_sound_player.play()
	update_menu_state(PauseMenuStates.INACTIVE)
	Globals.story_manager.change_story_node("MainMenu")
	Globals.player.update_game_state(Player.PlayerGameStates.UNPAUSED)


func _on_deny_button_button_up() -> void:
	stamp_sound_player.play()
	update_menu_state(PauseMenuStates.INACTIVE)
	Globals.player.update_game_state(Player.PlayerGameStates.UNPAUSED)
	
