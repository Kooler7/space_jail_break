extends Node2D


@onready var camera : Camera2D = Settings.camera

  
var cam_coordinates : Array = [
	Vector2(0, 0),
	Vector2(1920, 1080)
]

enum CameraPositions {
	SELL_FRONT,
	SELL_BACK,
	SELL_RIGHT
}
var current_cp : CameraPositions = CameraPositions.SELL_FRONT

func check_camera_position(new_position) -> void:
	match new_position:
		CameraPositions.SELL_FRONT:
			camera.position = cam_coordinates[CameraPositions.SELL_FRONT]
			current_cp = CameraPositions.SELL_FRONT
		CameraPositions.SELL_BACK:
			camera.position = cam_coordinates[CameraPositions.SELL_BACK]
			current_cp = CameraPositions.SELL_BACK
