#player.gd
class_name Player

extends Node2D

const UI = preload("res://GUI/ui/ui.gd")
const BlackScreen = preload("res://GUI/black_screen/black_screen.gd")
const Movement = preload("res://player/player_movement/player_movement.gd")



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

#Текст передаваемый интерактивным объектом
@export var explainer_text : String = ""


@onready var ui : UI = $UI
@onready var black_screen : BlackScreen = $BlackScreen
@onready var camera : Camera2D = $Camera2D
@onready var movement : Movement = $PlayerMovement



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
				return
			PlayerLoadingStates.LOADING:
				is_can_pause = false
				ui.mouse_shield.set_mouse_filter(Control.MOUSE_FILTER_STOP)
				await black_screen.popin()
				current_loading_state = PlayerLoadingStates.LOADING
				return


##Обработка изменения состояния жизни игрока
func update_health_state(new_state : PlayerHealthStates) -> void:
	if new_state != current_health:
		match new_state:
			PlayerHealthStates.ALIVE:
				ui.toggle_mouse_shield(ui.MouseShieldDefault, Control.MOUSE_FILTER_IGNORE)
				current_health = PlayerHealthStates.ALIVE
			PlayerHealthStates.DEAD:
				ui.toggle_mouse_shield(ui.MouseShieldRed, Control.MOUSE_FILTER_STOP)
				current_health = PlayerHealthStates.DEAD

##Обработка состояния игрока на уровне
func update_level_state(new_state : PlayerLevelStates)-> void:
	if new_state != current_level_state:
		if current_health == PlayerHealthStates.ALIVE and current_game_state == PlayerGameStates.UNPAUSED:
			match new_state:
				PlayerLevelStates.IN_WORLD:
					ui.toggle_mouse_shield(ui.MouseShieldDefault, Control.MOUSE_FILTER_IGNORE)
					current_level_state = PlayerLevelStates.IN_WORLD
					return
				PlayerLevelStates.IN_DIALOGUE:
					ui.toggle_mouse_shield(ui.MouseShieldGray, Control.MOUSE_FILTER_STOP)
					current_level_state = PlayerLevelStates.IN_DIALOGUE
					ui.hide_explainer()
					current_in_world_state = PlayerInWorldStates.CAN_MOVE
					return


##Обработка состояния игрока в мире
func update_in_world_state(new_state : PlayerInWorldStates) -> void:
	if new_state != current_in_world_state:
		if current_health == PlayerHealthStates.ALIVE and current_game_state == PlayerGameStates.UNPAUSED:
			if current_level_state == PlayerLevelStates.IN_WORLD:
				match  new_state:
					PlayerInWorldStates.EXPLAIN:
						ui.show_explainer(explainer_text)
						current_in_world_state = PlayerInWorldStates.EXPLAIN
					PlayerInWorldStates.CAN_MOVE:
						ui.hide_explainer()
						current_in_world_state = PlayerInWorldStates.CAN_MOVE
