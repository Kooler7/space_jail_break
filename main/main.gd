#main.gd
class_name Main

extends Node

var loading_level_path : String = ""
var loading_constructor_path : String = ""
var loading_status : int
var loading_progress : Array[float]
var is_loading_starting : bool = false


@onready var black_screen : Node2D = $BlackScreen
@onready var level_viewer : Node = $LevelVeiwer


func _ready() -> void:
	Settings.camera = $Camera2D
	Globals.main = self
	Globals.story_manager.change_story_node("MainMenu")


func _process(delta: float) -> void:
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
	#Проверка количества загруженных уровней, если больше нуля,
	#то включается заход в темное
	var levels : int = level_viewer.get_child_count()
	if levels > 0:
		await black_screen.popin()
	
	#Передача в лоадер пути нового уровня и переключение переменной в true
	ResourceLoader.load_threaded_request(loading_level_path)
	is_loading_starting = true
	#timer.start()
	#await  timer.timeout
	#loading_screen.show()


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
	#Запуск функции инстанцирования конструктора уровня
	instance_level_constructor()
	#Запуск функции очистки пуией
	clear_paths()
	#Запуск функции выхода из черного
	await black_screen.popout()
	#Проверка количества инстанцированных уровней и 
	#запуск функции удаления старого уровня
	if level_viewer.get_child_count() > 1:
		remove_older_level()

##Инстанцирование и запуск конструктора уровня
func instance_level_constructor() -> void:
	#Если у данного уровня есть конструктор
	if loading_constructor_path:
		#Получение уровня в переменную
		var loaded_level = level_viewer.get_child(1)
		#Загрузка и инстанцирование конструктора в переменную
		var level_constructor = load(loading_constructor_path).instantiate()
		#Передача переменной с конструктором в уровень
		loaded_level.constructor = level_constructor
		#Запуск конструктора в уровне
		loaded_level.init_constuctor()

#Функция очистки путей
func clear_paths() -> void:
	loading_constructor_path = ""
	loading_level_path = ""
