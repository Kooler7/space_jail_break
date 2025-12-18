#dialogue_box.gd
extends TextureRect


const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_TIME : float = 0.1
const START_RATIO : int = 0
const FINISH_RATIO : int = 1
const LETTER_SPEED : float = 0.02

enum VisibilityStates {
	POP_IN,
	POP_OUT,
	Fill_TEXT,
	FILL_OPTIONS,
	REMOVE_OPTIONS
}
var current_visibility_state : VisibilityStates = VisibilityStates.POP_OUT


var options : Array = []
var text : String = ""


@onready var paper : AnimatedSprite2D = $AnimatedSprite2D
@onready var text_field : Label = $Text
@onready var options_pool : VBoxContainer = $Buttons


func update_visibility_state(new_visibility_state: VisibilityStates) -> void:
	if current_visibility_state != new_visibility_state:
		match new_visibility_state:
			VisibilityStates.POP_IN:
				await _dialogue_box_popin()
				current_visibility_state = VisibilityStates.POP_IN
				return
			VisibilityStates.POP_OUT:
				await _dialogue_box_popout()
				current_visibility_state = VisibilityStates.POP_OUT
				return
			VisibilityStates.Fill_TEXT:
				await _text_typing(text)
				return
			VisibilityStates.FILL_OPTIONS:
				if current_visibility_state == VisibilityStates.POP_IN:
					await  _fill_options(options)
					current_visibility_state = VisibilityStates.FILL_OPTIONS
				else :
					await _dialogue_box_popin()
					await  _fill_options(options)
					current_visibility_state = VisibilityStates.FILL_OPTIONS
				return
			VisibilityStates.REMOVE_OPTIONS:
				if current_visibility_state == VisibilityStates.FILL_OPTIONS:
					await _remove_options()
					current_visibility_state = VisibilityStates.REMOVE_OPTIONS
				return
		return


##Появление диалогового окна
func _dialogue_box_popin() -> void:
	#Создание Tween
	var modulate_tween = create_tween()
	#Запуск Tween
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_TIME)
	modulate_tween.play()
	paper.play("default")
	await modulate_tween.finished
	paper.play("default")
	await paper.animation_finished
	text_field.show()
	modulate = FINISH_MODULATE
	#Включение перехвата событий мыши
	mouse_filter = MOUSE_FILTER_STOP
	return

##Убирание диалогового окна
func _dialogue_box_popout() -> void:
	#Выключение перехвата событий мыши
	mouse_filter = MOUSE_FILTER_IGNORE
	#Создание Tween
	var modulate_tween = create_tween()
	#Запуск Tween
	modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_TIME)
	modulate_tween.play()
	text_field.hide()
	if paper.is_playing():
		paper.pause()
	paper.play_backwards("default")
	await modulate_tween.finished
	modulate = START_MODULATE
	return

##Печатанье текста
func _text_typing(text : String) -> void:
	#Выключение перехвата событий мыши
	mouse_filter = MOUSE_FILTER_IGNORE
	#Создание Tween
	var ratio_tween = create_tween()
	#Проверка наличия текста
	if text == null:
		print("Текст недоступен!!!")
	else:
		#Сброс видимости текста
		text_field.visible_ratio = START_RATIO
		#Присвоение текста в переменную
		text_field.text = text
		#Вычисление скорости печати
		var typing_speed = text.length() * LETTER_SPEED
		#Запуск Tween
		ratio_tween.tween_property(text_field, "visible_ratio", FINISH_RATIO, typing_speed)
		ratio_tween.play()
		await ratio_tween.finished
		#Включение перехвата событий мыши
		mouse_filter = MOUSE_FILTER_STOP
	return


##Отображение опций диалога
func _fill_options(data : Array) -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	#Сброс текста в пустую строку
	text_field.text = ""
	#Перебор массива data
	for item in data:
		#Инстанцирование кнопок опций из адресов в массиве
		var option : PackedScene = item
		var child : Button = option.instantiate()
		options_pool.add_child(child)
	return

##Удаление всех кнопок опций диалога
func _remove_options() -> void:
	var option_buttons = options_pool.get_children()
	if option_buttons.is_empty() == false:
		for button in option_buttons:
			button.queue_free()
	return


##Перехват клика по диалоговому окну
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		DialogueManager.change_dialogue_node()
