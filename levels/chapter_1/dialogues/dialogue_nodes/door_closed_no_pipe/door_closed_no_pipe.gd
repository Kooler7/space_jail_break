extends Node


var dialogue : Dictionary = {
	"is_random_start" : true,
	"random_range" : [1, 3],
	"Line_1" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Чертову дверь заклинило намертво!",
		"Next_line" : -1
	},
	"Line_2" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Мотор сгорел напрочь!",
		"Next_line" : -1
	},
	"Line_3" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Черт! Чтож мне делать с этой дверью?",
		"Next_line" : -1
	}
}
