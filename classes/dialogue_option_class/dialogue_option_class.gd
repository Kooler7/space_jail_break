@icon("res://assets/icons_classes/DialogueOptionClass.png")
class_name DialogueOption
extends Button


func option_action() -> void:
	pass



func _on_toggled(toggled_on: bool) -> void:
	DialogueManager._on_option_clicked(self)
