#character_avatar_class.gd
@icon("res://assets/icons_classes/character_avatar_class.png")
class_name ChacrterAvatarClass

extends Sprite2D

const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_SPEED : float = 0.1


func popin() -> void:
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
	return
