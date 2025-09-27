#player.gd
class_name Player

extends Node2D

const MouseShieldRed = Color(1, 0, 0, 0.2)
const MouseShieldGray = Color(0, 0, 0, 0.8)
const MouseShieldDefault = Color(0, 0, 0, 0)

var reached_level : String
var player_global_decisions : Dictionary = {
	"Help_Dinia" : false,
}
var player_chapter_decisions : Dictionary

var current_game_object : Node2D
var is_game_started : bool = false

@onready var avatar : Sprite2D = $PlayerAvatar
#@onready var dialogue_manager : Node = $DialogueManager
#@onready var game_object_holder : Node2D = $GameObject
@onready var camera : Camera2D = $Camera2D
@onready var mouse_shield : Control = $MouseShield
@onready var explaner : Node2D = $Explaner
@onready var dialogue_box : TextureRect = $DialogueBox



func _ready() -> void:
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#mouse_shield.color = MouseShieldDefault
	Settings.camera = camera
	Globals.player = self


func on_player_avatar_called() -> void:
	await avatar.popin()

func on_player_avatar_dismissed() -> void:
	await avatar.popout()


#func on_game_object_clicked() -> void:
	#mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	##mouse_shield.color = MouseShieldGray
	#explaner.popout()


func on_game_object_hovered(new_text: String)-> void:
	explaner.text.text = new_text
	explaner.popin()

func on_game_object_unhovered()-> void:
	explaner.popout()

func on_dialogue_started() ->void:
	explaner.popout()
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	await dialogue_box.dialogue_box_popin()

func on_dialogue_completed() -> void:
	await dialogue_box.dialogue_box_popout()
	dialogue_box.text_field.text = ""
	await avatar.popout()
	mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
