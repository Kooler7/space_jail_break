#settings.gd
extends Node

@onready var window : Window = get_window()


enum ScreenStates {
	WINDOWED,
	FULLSCREEN
}
var current_screen_state : ScreenStates

var camera : Camera2D
var full_screen : bool = false
var current_screen_resolution : String = "Default"
var screen_sizes : Dictionary = {
	"854x480" : Vector2(854, 480),
	"1280x720" : Vector2(1280, 720),
	"1366x768" : Vector2(1366, 768),
	"Default" : Vector2(1920, 1080)
	}

var languages : Array = ["en", "ru"]

#func _ready() -> void:
	#toggle_fullscreen(ScreenStates.WINDOWED)

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
			set_screen_resolution(screen_sizes["Default"], screen_sizes[current_screen_resolution])
		ScreenStates.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			current_screen_state = ScreenStates.FULLSCREEN

func set_language(language) -> void:
	TranslationServer.set_locale(language)
