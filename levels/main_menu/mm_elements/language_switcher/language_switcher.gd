extends HBoxContainer





func _on_russian_toggled(toggled_on: bool) -> void:
	Settings.set_language(Settings.languages[1])


func _on_english_toggled(toggled_on: bool) -> void:
	Settings.set_language(Settings.languages[0])
