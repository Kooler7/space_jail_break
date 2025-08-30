extends Node

#signal game_object_became_explane
#signal game_object_became_idle
#
#signal npc_became_talk
#signal puzzle_mouse_clicked
#signal object_mouse_clicked

signal game_object_clicked

##Сигналы из dialogue_manager.gd и dialogue_box.gd
#region
#Сигналы из dialogue_box.gd в dialogue_manager.gd
signal new_line_requested
signal dialogue_box_clicked
signal leave_option_clicked

#Сигнал из dialogue_manager.gd в player.gd и "game_object"
signal dialogue_completed
signal player_avatar_called
signal npc_avatar_called
#endregion
