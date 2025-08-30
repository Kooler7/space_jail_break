extends Node2D


var dialogue : Dictionary = {
	1 : "Player:Да уж, нихерово чуваку досталось... Все портроха наружу, блин.",
	2 : "Npc:Это ты, Змей? Что-то мне, кореш, не фортануло... Вовремя ты отлить встал...",
	3 : [
		"res://levels/chapter_1/dialogues/options/how_to_help.tscn",
		"res://levels/chapter_1/dialogues/options/leave.tscn"
	],
	4 : "Npc:Найди мне обезбола, а то чего-то совсем кисло..."
}

@onready var avatar : ChacrterAvatarClass = $BuddyAliveAvatar
