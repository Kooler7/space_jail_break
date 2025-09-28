extends Button


func _on_toggled(toggled_on: bool) -> void:
	DialogueManager.finish_dialogue()
