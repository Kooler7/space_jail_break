extends Node2D


@onready var player : Player = Globals.player
@onready var steam_sound : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var screen_1 : Node2D = $Screen1
@onready var screen_2 : Node2D = $Screen2
@onready var screen_3 : Node2D = $Screen3
@export var object_positions : Array

var interactive_objects_paths : Dictionary = {
	"Melon" : "res://levels/chapter_1/interactive_objects/melon_chapter_1/melon_chapter_1.tscn",
	"Door" : "res://levels/chapter_1/interactive_objects/cell_door/cell_door.tscn",
	"Pipe" : "res://levels/chapter_1/interactive_objects/pipe_screen_1/pipe_screen_1.tscn"
}
var chapter_decisions : Dictionary = {
	"pipe_picked_up" : false,
	"melon_first_dialogue_complete" : false
}


func _ready() -> void:
	Globals.player.player_chapter_decisions = chapter_decisions
	Globals.player.reached_level = name
	SaveLoad.save_game()
	steam_sound.play()
	place_interactive_objects()
	

func place_interactive_objects() -> void:
		for object_position in object_positions:
			var marker_node = get_node(object_position)
			var word_index = marker_node.name.find("Position")
			var part_name = marker_node.name.substr(0, word_index)
			var temp_scene = load(interactive_objects_paths[part_name])
			var interactive_object = temp_scene.instantiate()
			marker_node.add_child(interactive_object)
