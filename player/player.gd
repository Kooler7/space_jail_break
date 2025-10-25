#player.gd
class_name Player

extends Node2D

const UI = preload("res://GUI/ui/ui.gd")

#Состояния активноности и неактивности игрока для режима загрузки
enum PlayerActivityStates {
	ACTIVE,
	INACTIVE
}
@export var current_activity_state : PlayerActivityStates = PlayerActivityStates.INACTIVE

#Состояния жизни игрока
enum PlayerHealthStates {
	ALIVE,
	DEAD
}
@export var current_health : PlayerHealthStates = PlayerHealthStates.ALIVE

#Состояния игрока на уровне
enum PlayerLevelStates {
	IN_WORLD,
	IN_DIALOGUE
}
@export var current_level_state : PlayerLevelStates = PlayerLevelStates.IN_WORLD

#Состояния игрока в диалогах
enum PlayerInDialogueStates {
	SPEAK,
	LISTEN,
	CHOOSE
}
@export var current_in_dialogue_state : PlayerInDialogueStates = PlayerInDialogueStates.CHOOSE

#Состояния игрока в мире
enum PlayerInWorldStates {
	EXPLAIN,
	CAN_MOVE
}
@export var current_in_world_state : PlayerInWorldStates = PlayerInWorldStates.CAN_MOVE

enum PlayerGameStates {
	PAUSED,
	UNPAUSED
}
@export var current_game_state : PlayerGameStates = PlayerGameStates.UNPAUSED

#Аватар NPC с которым ведется диалог
var current_npc_avatar : PackedScene

#Текст передаваемый интерактивным объектом
var action_text : String = ""

#Кнопки выбора в диалоге
var choosing_options : Array

#Достигнутый уровень в игре
var reached_level : String = ""

#Глобальные решения игрока
var player_global_decisions : Dictionary = {
	"HelpMelonInCell" : false,
}

#Решения игрока на уровне
var player_chapter_decisions : Dictionary


@onready var ui : UI = $UI
@onready var camera : Camera2D = $Camera2D


func _ready() -> void:
	Globals.player = self
	Settings.camera = camera


##Обработка состояния активности и неактивности игрока
func update_activity_state(new_state : PlayerActivityStates) -> void:
	if new_state != current_activity_state:
		match new_state:
			PlayerActivityStates.ACTIVE:
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
				current_activity_state = PlayerActivityStates.ACTIVE
			PlayerActivityStates.INACTIVE:
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_STOP)
				current_activity_state = PlayerActivityStates.INACTIVE


##Обработка изменения состояния жизни игрока
func update_health_state(new_state : PlayerHealthStates) -> void:
	if new_state != current_health:
		match new_state:
			PlayerHealthStates.ALIVE:
				ui.toggle_mouse_filter(ui.MouseShieldDefault, Control.MOUSE_FILTER_IGNORE)
				current_health = PlayerHealthStates.ALIVE
			PlayerHealthStates.DEAD:
				ui.update_ui_state(ui.UiStates.DEAD)
				ui.toggle_mouse_filter(ui.MouseShieldRed, Control.MOUSE_FILTER_STOP)
				current_health = PlayerHealthStates.DEAD

##Обработка состояния игрока на уровне
func update_level_state(new_state : PlayerLevelStates)-> void:
	if new_state != current_level_state:
		if current_health == PlayerHealthStates.ALIVE and current_game_state == PlayerGameStates.UNPAUSED:
			match new_state:
				PlayerLevelStates.IN_WORLD:
					await ui.on_avatar_dismissed()
					await ui.on_dialogue_completed()
					ui.remove_object_avatar()
					ui.toggle_mouse_filter(ui.MouseShieldDefault, Control.MOUSE_FILTER_IGNORE)
					current_level_state = PlayerLevelStates.IN_WORLD
					return
				PlayerLevelStates.IN_DIALOGUE:
					update_in_world_state(PlayerInWorldStates.CAN_MOVE)
					ui.current_npc_avatar = current_npc_avatar
					ui.on_dialogue_started()
					ui.toggle_mouse_filter(ui.MouseShieldGray, Control.MOUSE_FILTER_STOP)
					current_level_state = PlayerLevelStates.IN_DIALOGUE
					return

##Обработка состояния игрока в диалогах
func update_in_dialogue_state(new_state : PlayerInDialogueStates) -> void:
	if new_state != current_in_dialogue_state:
		if current_health == PlayerHealthStates.ALIVE and current_game_state == PlayerGameStates.UNPAUSED and current_in_world_state == PlayerLevelStates.IN_DIALOGUE:
			match  new_state:
				
				PlayerInDialogueStates.SPEAK:
					await ui.on_avatar_dismissed()
					await ui.on_avatar_called(ui.player_avatar)
					await ui.dialogue_box.update_visibility_state(ui.dialogue_box.VisibilityStates.POP_IN)
					await ui.dialogue_box.text_typing(action_text)
					current_in_dialogue_state = PlayerInDialogueStates.SPEAK
					return
				
				PlayerInDialogueStates.LISTEN:
					await ui.on_avatar_dismissed()
					await ui.on_avatar_called(ui.npc_avatar)
					await ui.dialogue_box.update_visibility_state(ui.dialogue_box.VisibilityStates.POP_IN)
					await ui.dialogue_box.text_typing(action_text)
					current_in_dialogue_state = PlayerInDialogueStates.LISTEN
					return
				
				PlayerInDialogueStates.CHOOSE:
					ui.dialogue_box.options = choosing_options
					if current_in_dialogue_state == PlayerInDialogueStates.LISTEN:
						await ui.on_avatar_dismissed()
						await ui.on_avatar_called(ui.player_avatar)
					await ui.dialogue_box.update_visibility_state(ui.dialogue_box.VisibilityStates.FILL_OPTIONS)
					current_in_dialogue_state = PlayerInDialogueStates.CHOOSE
					return

##Обработка состояния игрока в мире
func update_in_world_state(new_state : PlayerInWorldStates) -> void:
	if new_state != current_in_world_state:
		if current_health == PlayerHealthStates.ALIVE and current_game_state == PlayerGameStates.UNPAUSED:
			if current_level_state == PlayerLevelStates.IN_WORLD:
				match  new_state:
					PlayerInWorldStates.EXPLAIN:
						ui.show_explainer(action_text)
						current_in_world_state = PlayerInWorldStates.EXPLAIN
					PlayerInWorldStates.CAN_MOVE:
						ui.hide_explainer()
						current_in_world_state = PlayerInWorldStates.CAN_MOVE
