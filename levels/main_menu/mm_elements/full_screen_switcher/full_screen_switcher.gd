#full_screen_switcher.gd
extends HBoxContainer

@onready var button : CheckButton = $CheckButton



func _on_check_button_toggled(toggled_on: bool) -> void:
	if button.button_pressed:
		Settings.toggle_fullscreen(Settings.ScreenStates.FULLSCREEN)
	elif !button.button_pressed:
		Settings.toggle_fullscreen(Settings.ScreenStates.WINDOWED)
