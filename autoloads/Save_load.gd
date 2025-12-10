extends Node

var save_game_path : String = "res://save_game.save"
var save_settings_path : String = "res://save_settings.save"



func save_settings() -> void:
	var save_data : Dictionary = {
		"CurrentScreenState" : Settings.current_screen_state,
		"CurrentScreenResolution" : Settings.current_screen_resolution,
		"CurrentLocale" : Settings.current_locale,
		"CurrentGlobalVolume" : Settings.current_global_volume
	}
	var file = FileAccess.open(save_settings_path, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()



func load_settings() -> void:
	if FileAccess.file_exists(save_settings_path) == false:
		print("Can't find saved settings")
		return
	elif FileAccess.file_exists(save_settings_path) == true:
		var file = FileAccess.open(save_settings_path, FileAccess.READ)
		var saved_data = file.get_var()
		file.close()
		Settings.current_screen_state = saved_data["CurrentScreenState"]
		Settings.current_screen_resolution = saved_data["CurrentScreenResolution"]
		Settings.current_locale = saved_data["CurrentLocale"]
		Settings.current_global_volume = saved_data["CurrentGlobalVolume"]
		Settings.set_screen_resolution(Settings.screen_sizes["Default"], Settings.screen_sizes[Settings.current_screen_resolution])
		Settings.toggle_fullscreen(Settings.current_screen_state)
		Settings.set_language(Settings.current_locale)
		Settings.set_global_volume(Settings.current_global_volume)


func save_game() -> void:
	var save_data : Dictionary = {
		"current_level" : GameState.current_level,
		"global_decisions" : GameState.global_decisions,
		"global_flags" : GameState.global_flags,
		"inventory" : GameState.inventory
	}
	var file = FileAccess.open(save_game_path, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game() -> void:
	if FileAccess.file_exists(save_game_path) == false:
		print("Can't find saved game")
		return
	elif FileAccess.file_exists(save_game_path) == true:
		var file = FileAccess.open(save_game_path, FileAccess.READ)
		var saved_data = file.get_var()
		GameState.current_level = saved_data["current_level"]
		GameState.global_flags = saved_data["global_flags"]
		GameState.global_decisions = saved_data["global_decisions"]
		GameState.inventory = saved_data["inventory"]
