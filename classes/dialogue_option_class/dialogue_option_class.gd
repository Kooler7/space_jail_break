@icon("res://assets/icons_classes/DialogueOptionClass.png")
class_name DialogueOption
extends Button


@export var next_dialogue_node_name : String ## Имя следующего узла диалога при нажатии этого выбора



func _on_toggled(toggled_on: bool) -> void:
	DialogueManager.on_option_made(self)
