extends Node


var dialogue : Dictionary = {
	"Line_1" : {
		"Type" : "Random",
		"Random_range" : [2, 4],
	},
	"Line_2" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Чертову дверь заклинило намертво!",
		"Next_line" : -1
	},
	"Line_3" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Мотор сгорел напрочь!",
		"Next_line" : -1
	},
	"Line_4" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Черт! Что ж мне делать с этой дверью?",
		"Next_line" : -1
	}
}
