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
	погиб под обломками в своей камере во время инцидента 16 Маи 25 года Э.Н.О.
	"
}

func _ready() -> void:
	previous_level_name = "Chapter1"
	next_level_name = "Chapter2"
	choose_report()

func choose_report() -> void:
	var summary : String = ""
	var report : String = ""
	if Globals.player.is_player_alive == true:
		if Globals.player.player_global_decisions["HelpMelonInCell"] == false:
			send_report(summaries["is_player_alive"]["LeaveMelon"])
			#report = tr(summary)
			#print_report(report)
		elif Globals.player.player_global_decisions["HelpMelonInCell"] == true:
			send_report(summaries["is_player_alive"]["HelpMelon"])
			#report = tr(summary)
			#print_report(report)
	elif Globals.player.is_player_alive == false:
		send_report(summaries["is_player_dead"])
		#report = tr(summary)
		#print_report(report)

func send_report(summary : String) -> void:
	var report = tr(summary)
	print_report(report)
