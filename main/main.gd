#main.gd
class_name Main

extends Node

var loading_level_path = "res://levels/main_menu/main_menu.tscn"
var loading_status : int
var loading_progress : Array[float]
var is_loading_starting : bool = false


@onready var black_screen : Sprite2D = $BlackScreen
@onready var loading_screen : Control = $LoadingScreen
@onready var level_viewer : Node = $LevelVeiwer
@onready var timer : Timer = $Timer



func _ready() -> void:
	Settings.camera = $Camera2D
	Globals.main = self
	start_loading()




func _process(delta: float) -> void:
		if is_loading_starting:
			loading_status = ResourceLoader.load_threaded_get_status(loading_level_path, loading_progress)
		
			match loading_status:
				ResourceLoader.THREAD_LOAD_IN_PROGRESS:
					loading_screen.progress_bar.value = loading_progress[0] * 100 # Change the ProgressBar value
				ResourceLoader.THREAD_LOAD_LOADED:
					loading_screen.progress_bar.value = 100
					is_loading_starting = false
					timer.stop()
					remove_existing_level()
				ResourceLoader.THREAD_LOAD_FAILED:
					print("Error. Could not load Resource")


func start_loading() -> void:
	var levels : int = level_viewer.get_child_count()
	if levels > 0:
		await black_screen.popin()
	ResourceLoader.load_threaded_request(loading_level_path)
	is_loading_starting = true
	timer.start()
	await  timer.timeout
	loading_screen.show()


func remove_existing_level() -> void:
	var levels : int = level_viewer.get_child_count()
	if levels > 0:
		var children : Array = level_viewer.get_children()
		for child in children:
			child.queue_free()
		inctance_level()
	else:
		inctance_level()


func inctance_level() -> void:
	var new_level : Node = ResourceLoader.load_threaded_get(loading_level_path).instantiate()
	level_viewer.add_child(new_level)
	loading_screen.hide()
	await black_screen.popout()
