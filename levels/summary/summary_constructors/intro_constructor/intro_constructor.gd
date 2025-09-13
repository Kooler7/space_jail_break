extends SummaryConstructor


#Сообщение в рапорте
var summaries : Dictionary = {
	0 : "Гор Врайман. Поступил  25 Април 25 года Э.Н.О"
}

func _ready() -> void:
	#Указание имен узлов истории для переключения при нажатии кнопки
	story_node_names = ["MainMenu", "Chapter_1"]
	#Вызов фукций в классе
	buttons_loading()
	init_constructor()
	print_summary(summaries[0])
