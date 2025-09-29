extends Node


var dialogue : Dictionary = {
	"Line_1" : {
		"Type" : "Random",
		"Random_range" : [2, 5],
	},
	"Line_2" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Дайте мне точку опоры и я сдвину землю!",
		"Next_line" : 6
	},
	"Line_3" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Момент сил равен приложенной силе, умноженной на длину плеча!",
		"Next_line" : 6
	},
	"Line_4" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Если бы эта труба была у меня в руках ещё пять минут назад, я уже был бы на другом конце коридора. Но я слишком долго анализировал этот самый замок",
		"Next_line" : 6
	},
	"Line_5" : {
		"Type" : "Text",
		"Character" : "Player",
		"Words" : "Дверь закрыта — значит, кто-то не выполнил условие «быть открытой». Обычно это требует отжимания…",
		"Next_line" : 6
	},
	"Line_6" : {
		"Type" : "Options",
		"Character" : "Player",
		"Paths" : [ 
			"res://levels/chapter_1/dialogues/options/try_door/try_door.tscn",
			"res://levels/chapter_1/dialogues/options/leave/leave.tscn"
		],
		"Next_line" : -1
	}
}
