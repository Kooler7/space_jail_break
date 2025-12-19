@icon("res://assets/icons_classes/DialogueOptionClass.png")
class_name DialogueOption
extends Button

## Имя следующего узла диалога при нажатии этого выбора
@export var next_dialogue_node_name : String 



func _on_toggled(toggled_on: bool) -> void:
	DialogueManager.on_option_made(self)
