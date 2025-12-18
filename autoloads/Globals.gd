extends Node


var _main : Main

var _player : Player

var _story_manager : StoryManager

var _current_object : InteractiveObject

var current_puzzle

var _dialogue_ui : DialogueUI


func set_main(object: Main) -> void:
	if object:
		_main = object

func get_main() -> Main:
	if _main:
		return _main
	return

func set_player(object: Player) -> void:
	if object:
		_player = object

func get_player() -> Player:
	if _player:
		return _player
	return

func set_current_object(object: InteractiveObject) -> void:
	if object:
		_current_object = object

func get_current_object() -> InteractiveObject:
	if _current_object:
		return _current_object
	return

func set_dialogue_ui(object: DialogueUI) -> void:
	if object:
		_dialogue_ui = object

func get_dialogue_ui() -> DialogueUI:
	if _dialogue_ui:
		return _dialogue_ui
	return

func set_story_manager(object: StoryManager) -> void:
	if object:
		_story_manager = object

func get_story_manager() -> StoryManager:
	if _story_manager:
		return _story_manager
	return
