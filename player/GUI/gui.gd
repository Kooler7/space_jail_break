extends Control


@onready var explaner : Label = $Explaner
@onready var animations : AnimationPlayer = $"../AnimationPlayer"
@onready var dialogue_box : TextureRect = $DialogueBox
@onready var dialogue_text : Label = $DialogueBox/Text

var trancfered_data_eraser : Dictionary = {"dialogue_text" : ""}




func explaner_popin() -> void:
	animations.play("explaner_popup")

func explaner_popout() -> void:
	if animations.current_animation == "explaner_popup" and animations.is_playing():
		animations.pause()
	animations.play_backwards("explaner_popup")
	return


func dialogue_box_popin() -> void:
	animations.play("bubble_popup")
	await animations.animation_finished
	animations.play("text_typing")
	await animations.animation_finished
	dialogue_box.mouse_filter = Control.MOUSE_FILTER_STOP
	return

func dialogue_box_popout() -> void:
	dialogue_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	print("dialogue_box_popout!")
	if animations.current_animation == "bubble_popup" and animations.is_playing():
		animations.pause()
	animations.play_backwards("bubble_popup")
	await animations.animation_finished
	return


func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Signals.emit_signal("dialogue_box_clicked", trancfered_data_eraser)
