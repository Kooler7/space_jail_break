extends ChapterPlayerMovement


func _ready() -> void:
	Globals.player_movement = self
	positions_coordinates = [
		Vector2(0, 0),
		Vector2(1920, 1080),
		Vector2(3840, 0)
	]
	current_player_position = PlayerPositions.SCREEN_1


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
