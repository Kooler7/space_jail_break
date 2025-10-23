#player.gd
class_name Player

extends Node2D



#Состояния здоровья
enum HealthStates {
	ALIVE,
	DEAD
}
var current_health : HealthStates = HealthStates.ALIVE

#Состояния действий игрока на уровне
enum LevelActionStates {
	SPEAK,
	LISTEN,
	EXPLAIN,
	INTERACT,
	IDLE
}
var current_level_action : LevelActionStates = LevelActionStates.IDLE
var action_text : String = ""

enum GameActionStates {
	ACTIVE,
	PAUSED,
	INACTIVE
}
var current_game_action : GameActionStates = GameActionStates.ACTIVE

var reached_level : String = ""

var player_global_decisions : Dictionary = {
	"HelpMelonInCell" : false,
}
var player_chapter_decisions : Dictionary

var is_player_alive : bool = true
#var is_game_started : bool = false

@onready var ui : Control = $UI
@onready var camera : Camera2D = $Camera2D
@onready var mouse_shield : ColorRect = $MouseShield


#var current_npc_avatar : PackedScene
#var npc_avatar : ChacrterAvatarClass
#var showed_avatar : ChacrterAvatarClass

func _ready() -> void:
	ui.update_ui_state(ui.UiStates.IDLE)
	Settings.camera = camera
	Globals.player = self


func update_health_state(new_health) -> void:
	match new_health:
		HealthStates.ALIVE:
			ui.update_ui_state(ui.UiStates.IDLE)
			current_health = HealthStates.ALIVE
		HealthStates.DEAD:
			ui.update_ui_state(ui.UiStates.DEAD)
			current_health = HealthStates.DEAD

func update_action_state(new_action : LevelActionStates) -> void:
	match new_action:
		LevelActionStates.SPEAK:
			ui.action_text = action_text
			await ui.update_ui_state(ui.UiStates.SPEAK)
			current_level_action = LevelActionStates.SPEAK
			return
		LevelActionStates.LISTEN:
			ui.action_text = action_text
			await ui.update_ui_state(ui.UiStates.LISTEN)
			current_level_action = LevelActionStates.LISTEN
			return
		LevelActionStates.EXPLAIN:
			ui.action_text = action_text
			ui.update_ui_state(ui.UiStates.EXPLAIN)
			current_level_action = LevelActionStates.EXPLAIN
		LevelActionStates.INTERACT:
			pass
		LevelActionStates.IDLE:
			ui.update_ui_state(ui.UiStates.IDLE)
			current_level_action = LevelActionStates.IDLE


func update_game_state(new_game_action : GameActionStates) -> void:
	match new_game_action:
		GameActionStates.PAUSED:
			pass
		GameActionStates.ACTIVE:
			ui.update_ui_state(ui.UiStates.ACTIVE)
			mouse_shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
		GameActionStates.INACTIVE:
			ui.update_ui_state(ui.UiStates.INACTIVE)
			mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
