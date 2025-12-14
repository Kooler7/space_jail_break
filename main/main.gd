#main.gd
class_name Main

extends Node

var loading_level_path : String = ""
var loading_status : int
var loading_progress : Array[float]
var is_loading_starting : bool = false



@onready var level_viewer : Node = $LevelVeiwer


func _ready() -> void:
	Globals.main = self
	SaveLoad.load_settings()
	SaveLoad.load_game()
	Globals.story_manager.change_story_node("MainMenu")


func _process(_delta: float) -> void:
		if is_loading_starting:
			loading_status = ResourceLoader.load_threaded_get_status(loading_level_path, loading_progress)
			match loading_status:
				ResourceLoader.THREAD_LOAD_LOADED:
					is_loading_starting = false
					instance_level()
				ResourceLoader.THREAD_LOAD_FAILED:
					print("Error. Could not load Resource")


##Старт загрузки
func start_loading() -> void:
	AudioManager.off_sounds()

	#Проверка количества загруженных уровней, если больше нуля,
	#то включается заход в темное и перевод игрока в неактивное состояние
	var levels : int = level_viewer.get_child_count()
	if levels > 0:
		Globals.player.update_health_state(Player.PlayerHealthStates.ALIVE)
		await Globals.player.update_loading_state(Player.PlayerLoadingStates.LOADING)
	#Передача в лоадер пути нового уровня и переключение переменной в true
	ResourceLoader.load_threaded_request(loading_level_path)
	is_loading_starting = true



##Удаление старого уровня
func remove_older_level() -> void:
	var child = level_viewer.get_child(0)
	child.queue_free()


##Инстанцирование загруженного уровня
func instance_level() -> void:
	
	#Инстанцирование загруженного уровня
	var new_level : Node2D = ResourceLoader.load_threaded_get(loading_level_path).instantiate()
	#Добавление в дерево
	level_viewer.add_child(new_level)
	#Проверка количества инстанцированных уровней и 
	#запуск функции удаления старого уровня
	if level_viewer.get_child_count() > 1:
		remove_older_level()
	#Запуск функции очистки пуией
	clear_paths()
	
	#Запуск функции выхода из черного и перевод игрока в активное состояние
	Globals.player.movement.check_player_position(Globals.player.movement.PlayerPositions.SCREEN_1)
	await Globals.player.update_loading_state(Player.PlayerLoadingStates.LOADED)
	AudioManager.on_sounds()
	
	
	


#Функция очистки путей
func clear_paths() -> void:
	loading_level_path = ""
