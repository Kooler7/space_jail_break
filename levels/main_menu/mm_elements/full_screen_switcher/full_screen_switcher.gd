#full_screen_switcher.gd
extends HBoxContainer

#Узел кнопки
@onready var button : TextureButton = $TextureButton
#Проигрыватель щелчка кнопки
@onready var button_click : AudioStreamPlayer2D = $ButtonClick

func _ready() -> void:
	#Нажатие кнопки в соответсвии с настройками
	if Settings.current_screen_state == Settings.ScreenStates.FULLSCREEN:
		button.button_pressed = true




func _on_texture_button_toggled(toggled_on: bool) -> void:
	button_click.play()
	if button.button_pressed:
		Settings.toggle_fullscreen(Settings.ScreenStates.FULLSCREEN)
	elif !button.button_pressed:
		Settings.toggle_fullscreen(Settings.ScreenStates.WINDOWED)
