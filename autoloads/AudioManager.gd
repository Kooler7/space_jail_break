extends Node

const NO_SOUND_VOLUME = -80
const CALL_BUTTON_VOLUME = 0
const OBJECTS_VOLUME = -5
const PRISON_ACTIVITY_VOLUME = -10
const AGENDA_VOLUME = -10.5
const VOLUME_SPEED = 0.3

##Выключение громкости шин кроме Master
func fading_sounds() -> void:
	var buses = AudioServer.bus_count
	for bus in buses:
		var current_bus_name = AudioServer.get_bus_name(bus)
		if current_bus_name != "Master":
			var current_bus_int = AudioServer.get_bus_index(current_bus_name)
			AudioServer.set_bus_volume_db(current_bus_int, NO_SOUND_VOLUME)

##Включение всех шин кроме Master
func rising_sounds() -> void:
	var buses = AudioServer.bus_count
	for bus in buses:
		var current_bus_name = AudioServer.get_bus_name(bus)
		match current_bus_name:
			"CallBtn_Bus":
				var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				AudioServer.set_bus_volume_db(current_bus_int, CALL_BUTTON_VOLUME)
			"Objects_Bus":
				var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				AudioServer.set_bus_volume_db(current_bus_int, OBJECTS_VOLUME)
			"PrisonActivity_Bus":
				var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				AudioServer.set_bus_volume_db(current_bus_int, PRISON_ACTIVITY_VOLUME)
			"Agenda_Bus":
				var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				AudioServer.set_bus_volume_db(current_bus_int, AGENDA_VOLUME)
