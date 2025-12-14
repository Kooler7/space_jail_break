extends Button


func _on_toggled(toggled_on: bool) -> void:
	DialogueManager._on_option_clicked()
	Globals.player.movement.check_player_position(Globals.player.movement.PlayerPositions.SCREEN_3)
	DialogueManager.finish_dialogue()
	GameState.set_flag(GameState.level_flags, "try_door", true)
