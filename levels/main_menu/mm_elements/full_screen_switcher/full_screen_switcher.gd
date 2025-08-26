#full_screen_switcher.gd
extends HBoxContainer

@onready var button : CheckButton = $CheckButton

func _ready() -> void:
	if Settings.current_screen_state == Settings.ScreenStates.FULLSCREEN:
		button.button_pressed = true

func _on_check_button_toggled(toggled_on: bool) -> void:
	if button.button_pressed:
		Settings.toggle_fullscreen(Settings.ScreenStates.FULLSCREEN)
	elif !button.button_pressed:
		Settings.toggle_fullscreen(Settings.ScreenStates.WINDOWED)
