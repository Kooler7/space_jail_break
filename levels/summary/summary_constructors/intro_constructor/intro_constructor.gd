extends SummaryConstructor

@onready var mouse_shield : Control = $MouseShield

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons_loading()
	for button in buttons_pool.get_children():
		button.pressed.connect(on_button_pressed.bind(button))
	print_summary()
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE


func on_button_pressed(button : Button) -> void:
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	if button.name == "SummaryAcceptBtn":
		Globals.story_manager.change_story_node("Chapter_1")
	elif button.name == "SummaryRejectBtn":
		Globals.story_manager.change_story_node("MainMenu")
