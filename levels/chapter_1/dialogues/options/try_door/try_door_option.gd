extends DialogueOption


func option_action() -> void:
	Globals.player.movement.check_player_position(Player.Movement.PlayerPositions.SCREEN_3)
	DialogueManager.on_dialogue_box_clicked()
	GameState.set_flag(GameState.level_flags, "try_door", true)
