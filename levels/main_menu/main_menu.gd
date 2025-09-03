#main_menu.gd
extends Node2D


@export var main_screen_buttons_group : ButtonGroup
@onready var version : Label = $VersionNumber
@onready var accept_button : TextureButton = $MainMenuCallBtn

var buttons_actions : Dictionary = {
	"MainMenuResumeBtn" : "on_resume_btn_pressed",
	"MainMenuStartBtn" : "on_start_btn_pressed",
	"MainMenuSettingsBtn" : "on_settings_btn_pressed",
	"MainMenuExitBtn" : "on_exit_button_pressed"
}
var current_button_name : String =""
@onready var camera : Camera2D = Settings.camera

  
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



func _ready() -> void:
	main_screen_buttons = main_screen_buttons_group.get_buttons()
	main_screen_buttons.sort()
	for button in main_screen_buttons:
		button.pressed.connect(on_main_screen_button_pressed.bind(button))
	
	accept_button.pressed.connect(on_accept_button_pressed)
	
	version.text = "Ver. " + ProjectSettings.get_setting("application/config/version")



func on_main_screen_button_pressed(button : TextureButton)-> void:
	current_button_name = button.name


func on_accept_button_pressed() ->void:
	call(buttons_actions[current_button_name])



func check_camera_position(new_position) -> void:
	match new_position:
		CameraPositions.MAIN:
			camera.position = cam_coordinates[CameraPositions.MAIN]
			current_cp = CameraPositions.MAIN
		CameraPositions.SETTINGS:
			camera.position = cam_coordinates[CameraPositions.SETTINGS]
			current_cp = CameraPositions.SETTINGS


func _on_back_btn_pressed() -> void:
	check_camera_position(CameraPositions.MAIN)


func on_settings_btn_pressed() -> void:
	check_camera_position(CameraPositions.SETTINGS)

func on_start_btn_pressed() -> void:
	Globals.main.loading_level_path = "res://levels/chapter_1/chapter_1.tscn"
	Globals.main.start_loading()

func on_resume_btn_pressed() -> void:
	print("Отказано!")

func  on_exit_button_pressed() -> void:
	get_tree().quit()
