#player.gd
class_name Player

extends Node2D

const UI = preload("res://GUI/ui/ui.gd")
const BlackScreen = preload("res://GUI/black_screen/black_screen.gd")


enum PlayerActivityStates {
	ACTIVE,
	INACTIVE
}
@export var current_activity_state : PlayerActivityStates = PlayerActivityStates.ACTIVE

#Состояния активноности и неактивности игрока для режима загрузки
enum PlayerLoadingStates {
	LOADING,
	LOADED
}
@export var current_loading_state : PlayerLoadingStates = PlayerLoadingStates.LOADED

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
	CHOOSE,
	IDLE
}
@export var current_in_dialogue_state : PlayerInDialogueStates = PlayerInDialogueStates.IDLE

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


var is_can_pause : bool = false

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
@onready var black_screen : BlackScreen = $BlackScreen
@onready var camera : Camera2D = $Camera2D


func _ready() -> void:
	Globals.player = self
	Settings.camera = camera


func _process(delta: float) -> void:
	if is_can_pause:
		if Input.is_action_just_released("ui_cancel"):
			if current_game_state == PlayerGameStates.UNPAUSED:
				await update_game_state(PlayerGameStates.PAUSED)
				return

##Обработка состояния активности и неактивности игрока
func update_activity_state(new_state : PlayerActivityStates) -> void:
	if current_activity_state != new_state:
		match  new_state:
			PlayerActivityStates.ACTIVE:
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
				current_activity_state = PlayerActivityStates.ACTIVE
			PlayerActivityStates.INACTIVE:
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_STOP)
				current_activity_state = PlayerActivityStates.INACTIVE

##Обработка состояния паузы
func update_game_state(new_state : PlayerGameStates) -> void:
	if current_game_state != new_state:
		match  new_state:
			PlayerGameStates.PAUSED:
				await ui.pause_menu.update_menu_state(ui.pause_menu.PauseMenuStates.ACTIVE)
				get_tree().paused = true
				current_game_state = PlayerGameStates.PAUSED
				return
			PlayerGameStates.UNPAUSED:
				await ui.pause_menu.update_menu_state(ui.pause_menu.PauseMenuStates.INACTIVE)
				get_tree().paused = false
				current_game_state = PlayerGameStates.UNPAUSED
				return


func update_loading_state(new_state : PlayerLoadingStates) -> void:
	if new_state != current_loading_state:
		match new_state:
			PlayerLoadingStates.LOADED:
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
				await black_screen.popout()
				is_can_pause = true
				current_loading_state = PlayerLoadingStates.LOADED
				print("LOADED")
				return
			PlayerLoadingStates.LOADING:
				is_can_pause = false
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_STOP)
				await black_screen.popin()
				current_loading_state = PlayerLoadingStates.LOADING
				print("LOADing")
				return


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
					await update_in_dialogue_state(PlayerInDialogueStates.IDLE)
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
				
				PlayerInDialogueStates.IDLE:
					await ui.on_avatar_dismissed()
					await ui.on_dialogue_completed()
					await ui.dialogue_box.update_visibility_state(ui.dialogue_box.VisibilityStates.REMOVE_OPTIONS)
					ui.remove_object_avatar()
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
