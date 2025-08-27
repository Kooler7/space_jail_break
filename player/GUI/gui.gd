extends Control


@onready var explaner : Label = $Explaner
@onready var animations : AnimationPlayer = $"../AnimationPlayer"
@onready var dialogue_box : TextureRect = $DialogueBox
@onready var dialogue_text : Label = $DialogueBox/Text
@onready var options_buttons_container : VBoxContainer = $Buttons

var trancfered_data_eraser : Dictionary = {"dialogue_text" : ""}

enum GuiStates {
	EXPLANER_SHOWING,
	EXPLANER_HIDING,
	DIALOGUE_SHOWING,
	DIALOGUE_HIDING,
}


func check_gui_states(new_state: GuiStates) -> void:
	match new_state:
		GuiStates.EXPLANER_SHOWING:
			explaner_popin()
		GuiStates.EXPLANER_HIDING:
			pass
		GuiStates.DIALOGUE_SHOWING:
			pass
		GuiStates.DIALOGUE_HIDING:
			pass



#Показ и скрытие блока Explaner
#region
func explaner_popin() -> void:
	animations.play("explaner_popup")

func explaner_popout() -> void:
	if animations.current_animation == "explaner_popup" and animations.is_playing():
		animations.pause()
	animations.play_backwards("explaner_popup")
	return
#endregion


#Показ и скрытие диалогового окна. Печатание текста
#region
func dialogue_box_popin() -> void:
	animations.play("bubble_popup")
	await animations.animation_finished
	text_type()
	#Включение перехвата событий мыши
	dialogue_box.mouse_filter = Control.MOUSE_FILTER_STOP
	return

func text_type() -> void:
	animations.play("text_typing")
	await animations.animation_finished
	return

func dialogue_box_popout() -> void:
	#Выключение перехвата событий мыши
	dialogue_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	print("dialogue_box_popout!")
	if animations.current_animation == "bubble_popup" and animations.is_playing():
		animations.pause()
	animations.play_backwards("bubble_popup")
	await animations.animation_finished
	return
#endregion


func popup_option_buttons(buttons_paths : Array) -> void:
	for path in buttons_paths:
		var button = load(path)
		options_buttons_container.add_child(button)


func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Signals.emit_signal("dialogue_box_clicked", trancfered_data_eraser)
