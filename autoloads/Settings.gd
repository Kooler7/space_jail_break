#settings.gd
extends Node

@onready var root = get_viewport()

var full_screen : bool = false
var screen_resolution : int = 0
var screen_sizes : Array = [
	Vector2(854, 480),
	Vector2(1280, 720),
	Vector2(1366, 768),
	Vector2(1920, 1080)
	]
