#resolution_switcher.gd
extends VBoxContainer

@export var resolutions_button_group : ButtonGroup

var resolution_buttons : Array
var my_array = [10, 20, 30, 40, 50]


func _ready() -> void:
	resolution_buttons = resolutions_button_group.get_buttons()
	resolution_buttons.sort()
	my_array.sort()
	for button in resolution_buttons:
		button.pressed.connect(on_button.bind(button))
	

func on_button(button : CheckBox):
	var size_0 = str(Settings.screen_sizes[0].x)+"x"+str(Settings.screen_sizes[0].y)
	var size_1 = str(Settings.screen_sizes[1].x)+"x"+str(Settings.screen_sizes[1].y)
	var size_2 = str(Settings.screen_sizes[2].x)+"x"+str(Settings.screen_sizes[2].y)
	var size_3 = str(Settings.screen_sizes[3].x)+"x"+str(Settings.screen_sizes[3].y)
	match button.name:
		size_0:
			Settings.screen_resolution = 0
			Settings.set_screen_resolution()
		size_1:
			Settings.screen_resolution = 1
			Settings.set_screen_resolution()
		size_2:
			Settings.screen_resolution = 2
			Settings.set_screen_resolution()
		size_3:
			Settings.screen_resolution = 3
			Settings.set_screen_resolution()



	
