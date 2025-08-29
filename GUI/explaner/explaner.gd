extends Label

const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_SPEED : float = 0.1


func explaner_popin() -> void:
	modulate = START_MODULATE
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
	modulate_tween.play()


func explaner_popout() -> void:
	modulate = FINISH_MODULATE
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
