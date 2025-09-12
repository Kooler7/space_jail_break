class_name StoryManager

extends Node

var current_story_node : StoryNode
var current_chapter_path : String


@onready var story_nodes : Array = get_children()

func _ready() -> void:
	Globals.story_manager = self
	current_story_node = $MainMenu



func parse_story_node() -> void:
	current_chapter_path = current_story_node.chapter_path
	Globals.main.loading_level_path = current_chapter_path
	Globals.main.start_loading()
	


func change_story_node(new_node_name : String) -> void:
	for node in story_nodes:
		if node.name == new_node_name:
			current_story_node = node
	parse_story_node()
