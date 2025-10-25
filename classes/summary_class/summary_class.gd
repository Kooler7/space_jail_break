@icon("res://assets/icons_classes/SummaryClass.png")
class_name SummaryClass

extends Node2D

@onready var report_text : Label = $ReportText
@onready var stamp_sound_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

var previous_level_name : String
var next_level_name : String

func _ready() -> void:
	Globals.player.update_activity_state(Player.PlayerActivityStates.ACTIVE)

func print_report(new_report : String) -> void:
	report_text.text = new_report


func _on_deny_button_button_up() -> void:
	stamp_sound_player.play()
	Globals.player.update_activity_state(Player.PlayerActivityStates.INACTIVE)
	Globals.story_manager.change_story_node(previous_level_name)


func _on_accept_button_button_up() -> void:
	stamp_sound_player.play()
	Globals.player.update_activity_state(Player.PlayerActivityStates.INACTIVE)
	Globals.story_manager.change_story_node(next_level_name)
