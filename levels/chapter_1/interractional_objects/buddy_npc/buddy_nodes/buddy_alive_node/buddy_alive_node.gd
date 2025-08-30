extends Node2D


#const START_MODULATE : Color = Color(1, 1, 1, 0)
#const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
#const MODULATION_SPEED : float = 0.1

var dialogue : Dictionary = {
	1 : "Player:Да уж, нихерово чуваку досталось... Все портроха наружу, блин.",
	2 : "Npc:Это ты, Змей? Что-то мне, кореш, не фортануло... Вовремя ты отлить встал...",
	3 : [
		"res://levels/chapter_1/dialogues/options/how_to_help.tscn",
		"res://levels/chapter_1/dialogues/options/leave.tscn"
	],
	4 : "Npc:Найди мне обезбола, а то чего-то совсем кисло..."
}

@onready var avatar : Sprite2D = $BuddyAliveAvatar


#func avatar_popin() -> void:
	#modulate = START_MODULATE
	#var modulate_tween = create_tween()
	#modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
	#modulate_tween.play()
#
#
#func avatar_popout() -> void:
	#modulate = FINISH_MODULATE
	#var modulate_tween = create_tween()
	#modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_SPEED)
	#modulate_tween.play()
