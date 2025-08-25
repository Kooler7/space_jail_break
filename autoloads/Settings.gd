#settings.gd
extends Node

@onready var root : Viewport = get_viewport()
@onready var window : Window = get_window()

func _ready() -> void:
	set_screen_resolution()

enum ScreenStates {
	WINDOWED,
	FULLSCREEN
}
var current_screen_state : ScreenStates = ScreenStates.WINDOWED


var full_screen : bool = false
var screen_resolution : int = 0
var screen_sizes : Array = [
	Vector2(854, 480),
	Vector2(1280, 720),
	Vector2(1366, 768),
	Vector2(1920, 1080)
	]


func set_screen_resolution() -> void:
	if screen_resolution == 0:
		window.size = screen_sizes[0]
		root.size = screen_sizes[0]
#		screen_metrics()
	elif screen_resolution == 1:
		window.size = screen_sizes[1]
		root.size = screen_sizes[1]
#		screen_metrics()
	elif screen_resolution == 2:
		window.size = screen_sizes[2]
		root.size = screen_sizes[2]
#		screen_metrics()
	elif screen_resolution == 3:
		window.size = screen_sizes[3]
		root.size = screen_sizes[3]
#		screen_metrics()

func toggle_fullscreen(new_state) -> void:
	match new_state:
		ScreenStates.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			set_screen_resolution()
			current_screen_state = ScreenStates.WINDOWED
		ScreenStates.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			set_screen_resolution()
			current_screen_state = ScreenStates.FULLSCREEN
	#full_screen = window.window_fullscreen
	#if full_screen == false:
		#full_screen = true
		#window.window_fullscreen = full_screen
		#await get_tree().idle_frame
		#await get_tree().idle_frame
		#set_screen_resolution()
	#elif full_screen == true:
		#full_screen = false
		#window.window_fullscreen = full_screen
		#await get_tree().idle_frame
		#await get_tree().idle_frame
		#set_screen_resolution()
