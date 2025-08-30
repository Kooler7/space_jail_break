extends Sprite2D


const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_SPEED : float = 0.1

func _ready() -> void:
	modulate = START_MODULATE


func buddy_avatar_popin() -> void:
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	await modulate_tween.finished
	modulate = FINISH_MODULATE
	return


func buddy_avatar_popout() -> void:
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	await modulate_tween.finished
	modulate = START_MODULATE
	return
