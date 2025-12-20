extends Node2D


@onready var _player : Player = Globals.get_player()
@onready var _steam_sound : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _screen_1 : Node2D = $Screen1
@onready var _screen_2 : Node2D = $Screen2
@onready var _screen_3 : Node2D = $Screen3
@export var _object_positions : Array


#Пути загрузки для интерактивных объектов
var _interactive_objects_paths : Dictionary = {
	"Melon" : "res://levels/chapter_1/interactive_objects/melon_chapter_1/melon_chapter_1.tscn",
	"Door" : "res://levels/chapter_1/interactive_objects/cell_door/cell_door.tscn",
	"Pipe" : "res://levels/chapter_1/interactive_objects/pipe_screen_1/pipe_screen_1.tscn"
}

var _level_flags : Dictionary = {
	"melon_first_dialogue_complete" : false,
	"pipe_picked_up" : false,
	"door_open" : false,
	"try_door" : false
}
var _level_decisions : Dictionary = {
	"pipe_picked_up" : false,
}


func _ready() -> void:
	#Подключение сигнала изменения этапа к функции
	GameState.flag_changed.connect(_on_level_flag_changed)
	#Сброс инвентаря
	GameState.inventory = []
	#Помещение игрока в начальные координаты
	_player.movement.check_player_position(Player.Movement.PlayerPositions.SCREEN_1)
	#Передача в GameState возможных этапов на уровне
	GameState.level_flags = _level_flags
	#Передача в GameState возможных решений на уровне
	GameState.level_decisions = _level_decisions
	#Передача в GameState имени достигнутого уровня
	GameState.current_level = name
	#Перевод игрока в состояние управления паузой игры
	_player.is_can_pause = true
	#Сохранение игры
	SaveLoad.save_game()
	#Включение звука
	_steam_sound.play()
	#Размещение интерактивных объектов на уровне
	place_interactive_objects()
	

#Функция загрузки и размещения интерактивных объектов на уровне
func place_interactive_objects() -> void:
		for object_position in _object_positions:
			var marker_node = get_node(object_position)
			var word_index = marker_node.name.find("Position")
			var part_name = marker_node.name.substr(0, word_index)
			var temp_scene = load(_interactive_objects_paths[part_name])
			var interactive_object = temp_scene.instantiate()
			marker_node.add_child(interactive_object)

#Функция обработки сигнала от GameState
func _on_level_flag_changed(flag_name, value) -> void:
	if flag_name == "try_door" and value == true:
		_player.movement.check_player_position(Player.Movement.PlayerPositions.SCREEN_3)
	if flag_name == "door_open" and value == true:
		_player.movement.check_player_position(Player.Movement.PlayerPositions.SCREEN_2)
