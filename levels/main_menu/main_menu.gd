#main_menu.gd
extends Node2D

const SELL_END_POSITION = Vector2(-1000, 0)
const SELL_SPEED = 0.5


@export var main_screen_buttons_group : ButtonGroup
@export var accepted_stream : AudioStreamOggVorbis
@export var denied_stream : AudioStreamOggVorbis
@export var prison_activities : Array



@onready var version : Label = $MainScreen/VersionNumber
@onready var accept_button : TextureButton = $MainScreen/MainMenuCallBtn
@onready var camera : Camera2D = Settings.camera
@onready var close_settings : TextureButton = $SettingsScreen/SettingsBG/CloseSettings
@onready var sell : Sprite2D = $MainScreen/Sell
@onready var buttons_shield : Control = $MainScreen/ButtonsShield
@onready var call_btn_speech : AudioStreamPlayer2D = $CallBtnSpeech
@onready var button_click : AudioStreamPlayer2D = $ButtonClick
@onready var prison_activity : AudioStreamPlayer2D = $PrisonActivity


var buttons_actions : Dictionary = {
	"MainMenuResumeBtn" : "on_resume_btn_pressed",
	"MainMenuStartBtn" : "on_start_btn_pressed",
	"MainMenuSettingsBtn" : "on_settings_btn_pressed",
	"MainMenuExitBtn" : "on_exit_button_pressed"
}
var current_button_name : String = ""

var cam_coordinates : Array = [
	Vector2(0, 0),
	Vector2(1920, 1080)
]

enum CameraPositions {
	MAIN,
	SETTINGS
}
var current_cp : CameraPositions = CameraPositions.MAIN

var main_screen_buttons : Array
var is_buttons_blocked : bool = false
var call_btn_speech_vol : float

func _ready() -> void:
	#Отключение блокировки кнопок
	buttons_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	play_prison_activity(prison_activities[0])
	
	
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
		buttons_shield.mouse_filter = Control.MOUSE_FILTER_STOP

	#Если нет нажатой кнопки
	else :
		#Включение блокировки кнопок
		buttons_shield.mouse_filter = Control.MOUSE_FILTER_STOP
		await play_call_response(denied_stream)
		#Отключение блокировки кнопок
		buttons_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE


##Контроль положения камеры при изменении состояния
func check_camera_position(new_position) -> void:
	match new_position:
		CameraPositions.MAIN:
			buttons_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
			camera.position = cam_coordinates[CameraPositions.MAIN]
			current_cp = CameraPositions.MAIN
		CameraPositions.SETTINGS:
			camera.position = cam_coordinates[CameraPositions.SETTINGS]
			current_cp = CameraPositions.SETTINGS


func play_prison_activity(activity_stream_path : String):
	var activity_stream : AudioStreamOggVorbis = AudioStreamOggVorbis.load_from_file(activity_stream_path )
	prison_activity.stream = activity_stream
	prison_activity.play()


func play_call_response(new_stream : AudioStreamOggVorbis) -> void:
	call_btn_speech.stream = new_stream
	call_btn_speech.play()
	await call_btn_speech.finished
	return

##Действия при нажатии кнопки закрытия настроек
func on_back_btn_pressed() -> void:
	button_click.play()
	check_camera_position(CameraPositions.MAIN)

##Действия при подтверждении нажатия кнопки "Настройка"
func on_settings_btn_pressed() -> void:
	await play_call_response(accepted_stream)
	check_camera_position(CameraPositions.SETTINGS)

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
	await sell_tween.finished
	return

##Действия при подтверждении нажатия кнопки "Продолжить"
func on_resume_btn_pressed() -> void:
	await play_call_response(denied_stream)
	#Отключение блокировки кнопок
	buttons_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE


##Действия при подтверждении нажатия кнопки "Выход"
func  on_exit_button_pressed() -> void:
	await play_call_response(accepted_stream)
	get_tree().quit()
