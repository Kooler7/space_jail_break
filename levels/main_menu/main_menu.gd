#main_menu.gd
extends Node2D

#Константы для анимации открытия клетки
const SELL_END_POSITION = Vector2(-1000, 0)
const SELL_SPEED = 0.5


@export var main_screen_buttons_group : ButtonGroup

#Переменные для файлов голоса вызова
@export var accepted_stream : AudioStreamOggVorbis
@export var denied_stream : AudioStreamOggVorbis

#Проигрыватели звуков
@export var agenda_players : Array
@export var prison_activities_piayers : Array
#Версия игры
@onready var version : Label = $Screen1/VersionNumber
#Кнопка вызова
@onready var accept_button : TextureButton = $Screen1/MainMenuCallBtn
##Камера игрока
#@onready var camera : Camera2D = Settings.camera
#Кнопка закрытия настроек
@onready var close_settings : TextureButton = $Screen2/SettingsBG/CloseSettings
#Спрайт клетки
@onready var sell : Sprite2D = $Screen1/Sell


#Проигрыватели звуков
@onready var door_opening : AudioStreamPlayer2D = $DoorOpening
@onready var call_btn_speech : AudioStreamPlayer2D = $CallBtnSpeech
@onready var button_click : AudioStreamPlayer2D = $ButtonClick

#Таймеры для рандомизации проигрывания звуков
@onready var prison_activity_timer : Timer = $PrisonActivityTimer
@onready var agenda_speech_timer : Timer = $AgendaSpeechTimer


#Словарь функций, срабатывающих при нажатии той или иной кнопки
var buttons_actions : Dictionary = {
	"MainMenuResumeBtn" : "on_resume_btn_pressed",
	"MainMenuStartBtn" : "on_start_btn_pressed",
	"MainMenuSettingsBtn" : "on_settings_btn_pressed",
	"MainMenuExitBtn" : "on_exit_button_pressed"
}
var current_button_name : String = ""

#Координаты для позиционирования камеры
var cam_coordinates : Array = [
	Vector2(0, 0),
	Vector2(1920, 1080)
]


var main_screen_buttons : Array


func _ready() -> void:
	#Отключение блокировки кнопок
	#Globals.player.update_game_state(Globals.player.GameActionStates.ACTIVE)
	Globals.player_movement.check_player_position(Globals.player_movement.PlayerPositions.SCREEN_1)
	choose_prison_activity(5)
	choose_agenda(2)

	
	
	#Присоединение сигналов кнопок меню
	main_screen_buttons = main_screen_buttons_group.get_buttons()
	main_screen_buttons.sort()
	for button in main_screen_buttons:
		button.pressed.connect(on_main_screen_button_pressed.bind(button))
	
	#Присоединение сигнала кнопки подтверждения действия
	accept_button.pressed.connect(on_accept_button_pressed)
	
	#Присоединение сигнала кнопки закрытия настройки
	close_settings.pressed.connect(on_back_btn_pressed)
	
	#Отображение версии
	version.text = "Ver. " + ProjectSettings.get_setting("application/config/version")


##Присваивание нажатой кнопки в переменную
func on_main_screen_button_pressed(button : TextureButton)-> void:
	button_click.play()
	current_button_name = button.name

##Подтверждени нажатия кнопки меню при нажатии кнопки вызова
func on_accept_button_pressed() ->void:
	button_click.play()
	#Если нажата какая-либо кнопка
	if current_button_name:
		#Вызов функции соответствующей имени нажатой кнопки из переменной
		call(buttons_actions[current_button_name])
		#Включение блокировки кнопок
		Globals.player.update_activity_state(Player.PlayerActivityStates.INACTIVE)

	#Если нет нажатой кнопки
	else :
		#Включение блокировки кнопок
		Globals.player.update_activity_state(Player.PlayerActivityStates.INACTIVE)
		await play_call_response(denied_stream)
		#Отключение блокировки кнопок
		Globals.player.update_activity_state(Player.PlayerActivityStates.ACTIVE)


##Действия при нажатии кнопки закрытия настроек
func on_back_btn_pressed() -> void:
	button_click.play()
	SaveLoad.save_settings()
	Globals.player_movement.check_player_position(Globals.player_movement.PlayerPositions.SCREEN_1)
	#Отключение блокировки кнопок
	Globals.player.update_activity_state(Player.PlayerActivityStates.ACTIVE)



##Действия при подтверждении нажатия кнопки "Настройка"
func on_settings_btn_pressed() -> void:
	await play_call_response(accepted_stream)
	Globals.player_movement.check_player_position(Globals.player_movement.PlayerPositions.SCREEN_2)
	Globals.player.update_activity_state(Player.PlayerActivityStates.ACTIVE)



##Действия при подтверждении нажатия кнопки "Старт"
func on_start_btn_pressed() -> void:
	await play_call_response(accepted_stream)
	await slide_sell()
	Globals.story_manager.change_story_node("SummaryIntro")


##Анимация открытия камеры
func slide_sell() -> void:
	var sell_tween : Tween = create_tween()
	sell_tween.tween_property(sell, "position", SELL_END_POSITION, SELL_SPEED)
	sell_tween.play()
	door_opening.play()
	await sell_tween.finished
	return

##Действия при подтверждении нажатия кнопки "Продолжить"
func on_resume_btn_pressed() -> void:
	if Globals.player.reached_level != "":
		await play_call_response(accepted_stream)
		await slide_sell()
		Globals.story_manager.change_story_node(Globals.player.reached_level)
	elif Globals.player.reached_level == "":
		await play_call_response(denied_stream)
	##Отключение блокировки кнопок
	Globals.player.update_activity_state(Player.PlayerActivityStates.ACTIVE)


##Действия при подтверждении нажатия кнопки "Выход"
func  on_exit_button_pressed() -> void:
	await play_call_response(accepted_stream)
	get_tree().quit()

##Выбор проигрывателя агитации и запуск функции проигрывания
func choose_agenda(wait_time : float) -> void:
	agenda_speech_timer.wait_time = wait_time
	agenda_speech_timer.start()
	await  agenda_speech_timer.timeout
	var play_or_not : int = randi_range(0, 1)
	if play_or_not < 1:
		choose_agenda(randf_range(5, 10))
	elif play_or_not > 0:
		await play_agenda(agenda_players[randi_range(0, 2)])
		choose_agenda(randf_range(5, 10))

##Выбор проигрывателя тюремной активности и запуск функции проигрывания
func choose_prison_activity(wait_time : float) -> void:
	prison_activity_timer.wait_time = wait_time
	prison_activity_timer.start()
	await prison_activity_timer.timeout
	var play_or_not : int = randi_range(0, 1)
	if play_or_not < 1:
		choose_prison_activity(randf_range(15, 20))
	elif play_or_not > 0:
		await play_prison_activity(prison_activities_piayers[randi_range(0, 2)])
		choose_prison_activity(randf_range(15, 20))


##Проигрывание агитации
func play_agenda(new_agenda : NodePath) -> void:
	var agenda : AudioStreamPlayer2D = get_node(new_agenda)
	agenda.play()
	await agenda.finished
	return


##Проигрывание звуков тюремной активности
func play_prison_activity(new_activity : NodePath) -> void:
	var activity : AudioStreamPlayer2D = get_node(new_activity)
	activity.play()
	await activity.finished
	return


##Проигрывание голосового ответа на нажатие кнопки "Вызов"
func play_call_response(new_stream : AudioStreamOggVorbis) -> void:
	call_btn_speech.stream = new_stream
	call_btn_speech.play()
	await call_btn_speech.finished
	return

###Выключение громкости шин кроме Master
#func fading_sounds() -> void:
	#var buses = AudioServer.bus_count
	#for bus in buses:
		#var current_bus_name = AudioServer.get_bus_name(bus)
		#if current_bus_name != "Master":
			#var current_bus_int = AudioServer.get_bus_index(current_bus_name)
			#AudioServer.set_bus_volume_db(current_bus_int, -80)
#
###Включение всех шин кроме Master
#func rising_sounds() -> void:
	#var buses = AudioServer.bus_count
	#for bus in buses:
		#var current_bus_name = AudioServer.get_bus_name(bus)
		#match current_bus_name:
			#"CallBtn_Bus":
				#var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				#AudioServer.set_bus_volume_db(current_bus_int, 0)
			#"Objects_Bus":
				#var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				#AudioServer.set_bus_volume_db(current_bus_int, -5)
			#"PrisonActivity_Bus":
				#var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				#AudioServer.set_bus_volume_db(current_bus_int, -10)
			#"Agenda_Bus":
				#var current_bus_int = AudioServer.get_bus_index(current_bus_name)
				#AudioServer.set_bus_volume_db(current_bus_int, -10.5)
