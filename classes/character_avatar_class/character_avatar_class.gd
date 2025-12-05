#character_avatar_class.gd
@icon("res://assets/icons_classes/character_avatar_class.png")
class_name CharacterAvatarClass

extends Sprite2D

#Константы для анимации появления и исчезания аватара
const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const START_POSITION : Vector2 = Vector2.ZERO
const FINISH_POSITION : Vector2 = Vector2(-48, -48)
const START_ROTATION : float = 0
const FINISH_ROTATION : float = -17
const MODULATION_SPEED : float = 0.1


#Функция появления аватара
func popin() -> void:
	if modulate != FINISH_MODULATE:
		#Создание Tween
		var modulate_tween = create_tween()
		var position_tween = create_tween()
		var rotation_tween = create_tween()
		#Запуск Tween
		rotation_tween.tween_property(self, "rotation_degrees", FINISH_ROTATION, MODULATION_SPEED)
		position_tween.tween_property(self, "position", FINISH_POSITION, MODULATION_SPEED)
		modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
		position_tween.play()
		modulate_tween.play()
		rotation_tween.play()
		await modulate_tween.finished
		modulate = FINISH_MODULATE
		return
	elif modulate == FINISH_MODULATE:
		return 

#Функция исчезания аватара
func popout() -> void:
	if modulate != START_MODULATE:
		#Создание Tween
		var modulate_tween = create_tween()
		var position_tween = create_tween()
		var rotation_tween = create_tween()
		#Запуск Tween
		rotation_tween.tween_property(self, "rotation_degrees", START_ROTATION, MODULATION_SPEED)
		position_tween.tween_property(self, "position", START_POSITION, MODULATION_SPEED)
		modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_SPEED)
		position_tween.play()
		modulate_tween.play()
		rotation_tween.play()
		await modulate_tween.finished
		modulate = START_MODULATE
		return
	elif modulate == START_MODULATE:
		return 
