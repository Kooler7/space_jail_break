extends Node2D



@onready var version : Label = $MainBG/VersionNumber
@onready var camera : Camera2D = $Camera2D

  
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

#var pic_1 = preload("res://assets/test_jpgs/4.jpg")
#var pic_2 = preload("res://assets/test_jpgs/355134-cat-meme-quote-funny-humor-grumpy-42.jpg")
#var pic_3 = preload("res://assets/test_jpgs/Animals___Cats_SELF_white_cat_095290_.jpg")
#var pic_4 = preload("res://assets/test_jpgs/f12fe53d19fa073038774720b0ef75f6.jpg")
#var pic_5 = preload("res://assets/test_jpgs/i.jpg")
#var pic_6 = preload("res://assets/test_jpgs/meglepett-macska.jpg")
#var pic_7 = preload("res://assets/test_jpgs/0c62615055ff1900688ad42c72b30b55.jpeg")
#var pic_8 = preload("res://assets/test_jpgs/9bfe57644761a34c1444cb0dd4e79094.jpg")
#var pic_9 = preload("res://assets/test_jpgs/90fabec49d86b364b1ba52c5c23df0c5.jpg")
#var pic_10 = preload("res://assets/test_jpgs/471baba01fc91c78a40664469e6aa92f.jpg")
#var pic_11 = preload("res://assets/test_jpgs/72109ba9e1ff595f34ed59f94349eb1b.jpg")
#var pic_12 = preload("res://assets/test_jpgs/245230.jpg")
#var pic_13 = preload("res://assets/test_jpgs/55117958-4177-l__2176.jpg")
#var pic_14 = preload("res://assets/test_jpgs/Animals___Cats_SELF_white_cat_095290_.jpg")
