#settings.gd
extends Node

@onready var window : Window = get_window()

#func _ready() -> void:
	#set_screen_resolution()

enum ScreenStates {
	WINDOWED,
	FULLSCREEN
}
var current_screen_state : ScreenStates = ScreenStates.WINDOWED

var camera : Camera2D
var full_screen : bool = false
var screen_resolution : int = 0
var screen_sizes : Array = [
	Vector2(854, 480),
	Vector2(1280, 720),
	Vector2(1366, 768),
	Vector2(1920, 1080)
	]


func check_screen_resolution() -> void:
	match  screen_resolution:
		0:
			set_screen_resolution(screen_sizes[3], screen_sizes[0])
		1:
			set_screen_resolution(screen_sizes[3], screen_sizes[1])
		2:
			set_screen_resolution(screen_sizes[3], screen_sizes[2])
		3:
			set_screen_resolution(screen_sizes[3], screen_sizes[3])


func set_screen_resolution(default_resolution : Vector2, new_resolution : Vector2):
		DisplayServer.window_set_size(new_resolution)
		window.content_scale_factor = default_resolution.x / new_resolution.x
		camera.zoom.x = 1/window.content_scale_factor
		camera.zoom.y = 1/window.content_scale_factor


func toggle_fullscreen(new_state) -> void:
	match new_state:
		ScreenStates.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			current_screen_state = ScreenStates.WINDOWED
		ScreenStates.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			current_screen_state = ScreenStates.FULLSCREEN
