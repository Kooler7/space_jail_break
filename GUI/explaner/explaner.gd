extends Node2D

const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_SPEED : float = 0.1

@onready var paper : AnimatedSprite2D = $Sprite2D
@onready var text : Label = $Label


func popin() -> void:
	text.hide()
	modulate = START_MODULATE
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	paper.play("default")
	await paper.animation_finished
	text.show()



func popout() -> void:
	modulate = FINISH_MODULATE
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_SPEED)
	modulate_tween.play()
	text.hide()
	if paper.is_playing():
		paper.pause()
	paper.play_backwards("default")
