extends SummaryClass


#Сообщение в рапорте
var summaries : Dictionary = {
	"is_player_alive" : {
		"HelpMelon" : "
		Во время инцидента, произошедшего 16 Маи 25 года Э.Н.О,
		Гор Врайман успел взломать подручными средствами дверь своей камеры
		до обрушения потолка. В 2:17 по полуночи он помог своему сокамернику 
		по кличке Дыня выбраться из камеры и покинул ее сам.
		",
		"LeaveMelon" : "
		Во время инцидента, произошедшего 16 Маи 25 года Э.Н.О,
		Гор Врайман успел взломать подручными средствами дверь своей камеры
		до обрушения потолка. В 2:17 по полуночи оставив своего сокамерника 
		по кличке Дыня на верную смерть, покинул камеру.
		"
	},
	"is_player_dead" : "
	Гор Врайман не успел выбраться из камеры до обрушения потолка и 
	погиб под обломками в своей камере вместе с сокамерником
	 во время инцидента 16 Маи 25 года Э.Н.О.
	"
}

func _ready() -> void:
	previous_level_name = "Chapter1"
	choose_report()

func choose_report() -> void:
	var summary : String = ""
	var report : String = ""
	if GameState.level_flags["door_open"]:
		next_level_name = "Chapter2"
		if GameState.global_decisions["melon_saved"] == false:
			send_report(summaries["is_player_alive"]["LeaveMelon"])
		elif GameState.global_decisions["melon_saved"] == true:
			send_report(summaries["is_player_alive"]["HelpMelon"])
	elif GameState.level_flags["door_open"] == false:
		next_level_name = "MainMenu"
		send_report(summaries["is_player_dead"])


func send_report(summary : String) -> void:
	var report = tr(summary)
	print_report(report)
