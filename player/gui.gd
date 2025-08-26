extends Control


@onready var explaner : Label = $Explaner
@onready var animations : AnimationPlayer = $"../AnimationPlayer"

enum InterfaceStates {
	EXPLANING,
	TALKING,
	CHOOSING,
	INTERACTING,
	IDLE
}
var current_gui_state : InterfaceStates = InterfaceStates.IDLE

func check_gui_state(new_state: InterfaceStates) -> void:
	match new_state:
		InterfaceStates.EXPLANING:
			show()
			explaner_popin()
		InterfaceStates.TALKING:
			pass
		InterfaceStates.INTERACTING:
			pass
		InterfaceStates.IDLE:
			await explaner_popout()
			hide()
		InterfaceStates.CHOOSING:
			pass

func explaner_popin() -> void:
	animations.play("explaner_popup")

func explaner_popout() -> void:
	if animations.current_animation == "explaner_popup" and animations.is_playing():
		animations.pause()
		animations.play_backwards("explaner_popup")
	return
