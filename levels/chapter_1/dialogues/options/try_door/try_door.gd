extends Button


func _on_toggled(toggled_on: bool) -> void:
	Globals.player_movement.check_player_position(Globals.player_movement.PlayerPositions.SCREEN_3)
	DialogueManager.finish_dialogue()
