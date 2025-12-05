@icon("res://assets/icons_classes/PlayerMovement.png")
extends Node

var positions_coordinates : Array = [
		Vector2(0, 0),
		Vector2(1920, 1080),
		Vector2(3840, 0)
	]

enum PlayerPositions {
	SCREEN_1,
	SCREEN_2,
	SCREEN_3
}
var current_player_position : PlayerPositions = PlayerPositions.SCREEN_1


func check_player_position(new_position) -> void:
	match new_position:
		PlayerPositions.SCREEN_1:
			Globals.player.position = positions_coordinates[PlayerPositions.SCREEN_1]
			current_player_position = PlayerPositions.SCREEN_1
		PlayerPositions.SCREEN_2:
			Globals.player.position = positions_coordinates[PlayerPositions.SCREEN_2]
			current_player_position = PlayerPositions.SCREEN_2
		PlayerPositions.SCREEN_3:
			Globals.player.position = positions_coordinates[PlayerPositions.SCREEN_3]
			current_player_position = PlayerPositions.SCREEN_3
