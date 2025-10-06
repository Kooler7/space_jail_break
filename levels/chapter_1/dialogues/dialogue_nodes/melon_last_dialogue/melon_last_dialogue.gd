extends Node



var dialogue : Dictionary = {
	"Line_1" : {
		"Type" : "Random",
		"Random_range" : [2, 4],
	},
	"Line_2" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "О! Ты все таки за мной вернулся!",
		"Next_line" : 5
	},
	"Line_3" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "Поможешь мне?",
		"Next_line" : 5
	},
	"Line_4" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "Черт! Не выспаться мне сегодня!",
		"Next_line" : 5
	},
	"Line_5" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Гор, это ты? Что-то мне нехорошо... Что произошло?",
		"Next_line" : 6
	},
	"Line_6" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Видимо в цеху кто-то накосячил и он бахнул. Мы так-то не сахар здесь варили.",
		"Next_line" : 7
	},
	"Line_7" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "А ты цел. Вовремя ты отлить встал. А мне чего-то не фортануло.",
		"Next_line" : 8
	},
	"Line_8" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Это не надолго. Сейчас остатки потолка упадут и нас завалит.",
		"Next_line" : 9
	},
	"Line_9" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "Ты башковитый, чего-нибудь придумаешь. Только, когда будешь линять про кореша не забудь.",
		"Next_line" : 10
	},
		"Line_10" : {
		"Type" : "Exicute",
		"Method" : "update_player_decisions",
		"Decision" : "melon_first_dialogue_complete",
		"Value" : true,
		"Next_line" : -1
	},
}
