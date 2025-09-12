extends SummaryConstructor



var summaries : Dictionary = {
	0 : "Гор Врайман. Поступил  25 Април 25 года Э.Н.О"
}

func _ready() -> void:
	story_node_names = ["MainMenu", "Chapter_1"]
	buttons_loading()
	init_constructor()
	print_summary(summaries[0])
