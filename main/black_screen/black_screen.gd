#black_screen.gd
class_name BlackScreen

extends ColorRect

@onready var animation : AnimationPlayer = $AnimationPlayer

enum BlackScreenStates {
	FADING_IN,
	FADING_OUT
}
@export var current_bs_state : BlackScreenStates


func check_state (new_bs_state : BlackScreenStates) -> void:
	match new_bs_state:
		BlackScreenStates.FADING_IN:
			current_bs_state = BlackScreenStates.FADING_IN
			animation.play_backwards("Fade_In_Out")
			await animation.animation_finished
		BlackScreenStates.FADING_OUT:
			current_bs_state = BlackScreenStates.FADING_OUT
			animation.play("Fade_In_Out")
			await animation.animation_finished
