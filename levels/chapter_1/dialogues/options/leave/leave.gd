extends Button


func _on_toggled(toggled_on: bool) -> void:
	DialogueManager._on_option_clicked()
	DialogueManager.finish_dialogue()
