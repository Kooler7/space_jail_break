#main_menu.gd
extends Node2D



@onready var version : Label = $MainBG/VersionNumber
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


func _ready() -> void:
	version.text = "Ver. " + ProjectSettings.get_setting("application/config/version")


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


func _on_settings_btn_pressed() -> void:
	check_camera_position(CameraPositions.SETTINGS)


func _on_start_btn_pressed() -> void:
	Globals.main.loading_level_path = "res://levels/chapter_1/chapter_1.tscn"
	Globals.main.start_loading()
