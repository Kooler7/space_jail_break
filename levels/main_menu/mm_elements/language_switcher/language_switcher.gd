extends HBoxContainer


@export var languages_buttons_group : ButtonGroup

@onready var button_click : AudioStreamPlayer2D = $ButtonClick

var languages_buttons : Array

func _ready() -> void:
	languages_buttons = languages_buttons_group.get_buttons()
	languages_buttons.sort()
	for button in languages_buttons:
		button.toggled.connect(on_button_toggled.bind(button))
		if button.name == Settings.current_language:
			button.button_pressed = true


func on_button_toggled(toggled_on : bool, button : TextureButton) -> void:
	button_click.play()
	Settings.set_language(Settings.languages[button.name])
