extends Node2D

#@export var constructors : Node


@export var constructors_paths : Dictionary = {
	"SummaryIntro" : "",
	"Chapter_1" : "",
	"Summary_1" : ""
}

var current_constructor : SummaryConstructor

func _ready() -> void:
	choose_constructor()



func choose_constructor() -> void:
	var constructor_node = load(constructors_paths[Globals.story_manager.current_story_node.name])
	current_constructor = constructor_node.instantiate()
	add_child(current_constructor)
	
