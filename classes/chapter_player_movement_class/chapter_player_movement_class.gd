#chapter_player_movement_class.gd
@icon("res://assets/icons_classes/PlayerMovement.png")
class_name ChapterPlayerMovement

extends Node


var positions_coordinates : Array = [

]

enum PlayerPositions {
	SCREEN_1,
	SCREEN_2,
	SCREEN_3
}
var current_player_position : PlayerPositions



func check_player_position(new_position) -> void:
	pass
