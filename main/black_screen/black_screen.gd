#black_screen.gd
extends Sprite2D

const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_SPEED : float = 1



func _ready() -> void:
	modulate = START_MODULATE
	#mouse_filter = MOUSE_FILTER_IGNORE

func popin() -> void:
	#mouse_filter = MOUSE_FILTER_STOP
	#Создание Tween
	var modulate_tween = create_tween()
	#Запуск Tween
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	await modulate_tween.finished
	modulate = FINISH_MODULATE
	return


func popout() -> void:
	#Создание Tween
	var modulate_tween = create_tween()
	#Запуск Tween
	modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	await modulate_tween.finished
	modulate = START_MODULATE
	#mouse_filter = MOUSE_FILTER_IGNORE
	return
