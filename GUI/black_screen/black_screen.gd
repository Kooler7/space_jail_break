#black_screen.gd
extends Node2D

const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_SPEED : float = 1

@onready var wire : Sprite2D = $Wire

func _ready() -> void:
	hide()
	modulate = START_MODULATE

func _process(delta: float) -> void:
	if modulate != START_MODULATE:
		wire.rotate(0.017)
		if wire.rotation_degrees >= 360:
			wire.rotation_degrees = 0
		

func popin() -> void:
	#Создание Tween
	var modulate_tween = create_tween()
	#Запуск Tween
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	show()
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
	hide()
	modulate = START_MODULATE
	return
