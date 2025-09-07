class_name StoryManager

extends Node

var current_story_node : StoryNode
var current_chapter_path : String
var current_chapter_constructor : String

var story_nodes : Array

func _ready() -> void:
	Globals.story_manager = self
	get_all_nodes(self)
	print(story_nodes)
	current_story_node = $MainMenu



func parse_story_node() -> void:
	current_chapter_path = current_story_node.chapter_path
	if current_story_node.chapter_constructor_path:
		current_chapter_constructor = current_story_node.chapter_constructor_path
		Globals.main.loading_constructor_path = current_chapter_constructor
	Globals.main.loading_level_path = current_chapter_path
	Globals.main.start_loading()


func change_story_node(new_node_name : String) -> void:
	for node in story_nodes:
		if node.name == new_node_name:
			current_story_node = node
	parse_story_node()

func get_all_nodes(node):
	for i in node.get_children():
		if i.get_child_count() > 0:
			story_nodes.push_back(i)
			get_all_nodes(i)
		else:
			story_nodes.push_back(i)
	
