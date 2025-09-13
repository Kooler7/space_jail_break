#resolution_switcher.gd
extends VBoxContainer

#Переменная для хранения ресрса Группа Кнопок
@export var resolutions_button_group : ButtonGroup
#Проигрыватель звука щелчка кнопки
@onready var button_click : AudioStreamPlayer2D = $ButtonClick

var resolution_buttons : Array


func _ready() -> void:
	resolution_buttons = resolutions_button_group.get_buttons()
	resolution_buttons.sort()
	for button in resolution_buttons:
		button.pressed.connect(on_button.bind(button))
		if button.name == Settings.current_screen_resolution:
			button.button_pressed = true
	
	

func on_button(button : TextureButton):
	button_click.play()
	Settings.set_screen_resolution(Settings.screen_sizes["Default"], Settings.screen_sizes[button.name])
	Settings.current_screen_resolution = button.name
	
