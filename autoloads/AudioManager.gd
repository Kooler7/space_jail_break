extends Node

const NO_SOUND_VOLUME = -80
const CALL_BUTTON_VOLUME = 0
const OBJECTS_VOLUME = -5
const PRISON_ACTIVITY_VOLUME = -10
const AGENDA_VOLUME = -10.5
const BACKGROUND_MUSIC_VOLUME = -12
const VOLUME_SPEED = 0.2



##Выключение громкости шин кроме Master
func off_sounds() -> void:
	var buses = AudioServer.bus_count
	for bus in buses:
		var current_bus_name = AudioServer.get_bus_name(bus)
		if current_bus_name != "Master":
			var current_bus_int = AudioServer.get_bus_index(current_bus_name)
			fading_rising_sounds(current_bus_int, NO_SOUND_VOLUME)


##Включение всех шин кроме Master
func on_sounds() -> void:
	var current_bus_index : int
	var all_buses = AudioServer.bus_count
	for bus in all_buses:
		var current_bus_name = AudioServer.get_bus_name(bus)
		match current_bus_name:
			"CallBtn_Bus":
				current_bus_index = AudioServer.get_bus_index(current_bus_name)
				fading_rising_sounds(current_bus_index, CALL_BUTTON_VOLUME)
			"Objects_Bus":
				current_bus_index = AudioServer.get_bus_index(current_bus_name)
				fading_rising_sounds(current_bus_index, OBJECTS_VOLUME)
			"PrisonActivity_Bus":
				current_bus_index = AudioServer.get_bus_index(current_bus_name)
				fading_rising_sounds(current_bus_index, PRISON_ACTIVITY_VOLUME)
			"Agenda_Bus":
				current_bus_index = AudioServer.get_bus_index(current_bus_name)
				fading_rising_sounds(current_bus_index, AGENDA_VOLUME)
			"BackgroundMusic_Bus":
				current_bus_index = AudioServer.get_bus_index(current_bus_name)
				fading_rising_sounds(current_bus_index, BACKGROUND_MUSIC_VOLUME)



func set_bus_volume(target_volume : float, bus_index : int) -> void:
	AudioServer.set_bus_volume_db(bus_index, target_volume)

func fading_rising_sounds(bus_index : int, target_volume : float) -> void:
	var tween_volume = create_tween()
	tween_volume.tween_method(set_bus_volume.bind(bus_index), AudioServer.get_bus_volume_db(bus_index), target_volume, VOLUME_SPEED)
	tween_volume.play()



func set_master_volume(new_volume : float) -> void:
	var master_index : int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, new_volume)
	print(AudioServer.get_bus_volume_db(master_index))
