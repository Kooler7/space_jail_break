extends Node


var dialogue : Dictionary = {
	"Line_1" : {
		"Type" : "Random",
		"Random_range" : [2, 4],
	},
	"Line_2" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Дайте мне точку опоры и я сдвину землю!",
		"Next_line" : 5
	},
	"Line_3" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Момент сил равен приложенной силе, умноженной на длину плеча!",
		"Next_line" : 5
	},
	"Line_4" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Гравитация! Бессердечная ты сука!",
		"Next_line" : 5
	},
	"Line_5" : {
		"Type" : "Options",
		"Character" : "Player",
		"Paths" : [ 
			"res://levels/chapter_1/dialogues/options/try_door/try_door.tscn",
			"res://levels/chapter_1/dialogues/options/leave/leave.tscn"
		],
		"Next_line" : -1
	}
}
