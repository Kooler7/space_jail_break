class_name StoryManager

extends Node

@onready var current_story_node : StoryNode = $MainMenu


var current_chapter_path : String
var current_chapter_constructor : Node

func _ready() -> void:
	Globals.story_manager = self

func parse_story_node() -> void:
	current_chapter_path = current_story_node.chapter_path
	current_chapter_constructor = current_story_node.chapter_constructor
	Globals.main.loading_level_path = current_chapter_path
	Globals.main.start_loading()
