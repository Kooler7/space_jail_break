extends Node


var dialogue : Dictionary = {
	"Line_1" : {
		"Type" : "Random",
		"Random_range" : [2, 4],
	},
	"Line_2" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "О! Ты трубу нашел. Значит чего-нибудь придумаешь.",
		"Next_line" : -1
	},
	"Line_3" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "Поторопись! Иначе нам обоим крантец наступит.",
		"Next_line" : -1
	},
	"Line_4" : {
		"Type" : "Text",
		"Character" : "Npc",
		"Words" : "Ты башковитый. Сам что-нибудь придумаешь.",
		"Next_line" : -1
	},
}
