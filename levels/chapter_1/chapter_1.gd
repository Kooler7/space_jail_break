extends Node2D


@onready var player : Player = Globals.player
@onready var steam_sound : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var arrow : Sprite2D = $CellFront/TurnRight/Sprite2D

var chapter_decisions : Dictionary = {
	"pipe_picked_up" : false,
	"melon_first_dialogue_complete" : false
}
var cam_coordinates : Array = [
	Vector2(0, 0),
	Vector2(1920, 1080)
]

enum PlayerPositions {
	CELL_FRONT,
	CELL_BACK,
	CELL_RIGHT
}
var current_player_position : PlayerPositions = PlayerPositions.CELL_FRONT


func _ready() -> void:
	Globals.player.player_chapter_decisions = chapter_decisions
	Globals.player.reached_level = "Chapter_1"
	steam_sound.play()


func check_player_position(new_position) -> void:
	match new_position:
		PlayerPositions.CELL_FRONT:
			Globals.player.position = cam_coordinates[PlayerPositions.CELL_FRONT]
			current_player_position = PlayerPositions.CELL_FRONT
		PlayerPositions.CELL_BACK:
			Globals.player.position = cam_coordinates[PlayerPositions.CELL_BACK]
			current_player_position = PlayerPositions.CELL_BACK


func _on_area_2d_mouse_entered() -> void:
	arrow.show()


func _on_area_2d_mouse_exited() -> void:
	arrow.hide()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		check_player_position(PlayerPositions.CELL_BACK)
