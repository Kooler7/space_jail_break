extends Control

#const START_MODULATE : Color = Color(1, 1, 1, 0)
#const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
#const MODULATION_TIME : float = 0.1

#@onready var modulate_tween : Tween

#@onready var explaner : Label = $Explaner
#
##func _ready() -> void:
	##modulate_tween = create_tween()
#
###Показ и скрытие блока Explaner
###region
#func explaner_popin() -> void:
	#var modulate_tween = create_tween()
	#modulate_tween.tween_property(explaner, "modulate", FINISH_MODULATE, MODULATION_TIME)
	#modulate_tween.play()
#
#func explaner_popout() -> void:
	#var modulate_tween = create_tween()
	#modulate_tween.tween_property(explaner, "modulate", START_MODULATE, MODULATION_TIME)
	#modulate_tween.play()
	#modulate_tween.finished
	#return
