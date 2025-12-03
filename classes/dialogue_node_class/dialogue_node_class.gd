@icon("res://assets/icons_classes/DialogueNodeIcon.png")
class_name DialogueNode

extends Node

enum NodeTypes {
	RANDOMIZER,
	TEXT,
	OPTIONS,
	ACTION
}
@export var current_node_type : NodeTypes = NodeTypes.TEXT

@export var random_nodes : Array = []

@export var speaker : String = "Player"

@export_multiline var node_text : String = ""

@export var options : Array = []

@export var callable : String = ""

@export var next_node : String = "END"
