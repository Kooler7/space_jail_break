#dialogue_box.gd
extends TextureRect

const START_MODULATE : Color = Color(1, 1, 1, 0)
const FINISH_MODULATE : Color = Color(1, 1, 1, 1)
const MODULATION_TIME : int = 0.1
const START_RATIO : int = 0
const FINISH_RATIO : int = 1
const LETTER_SPEED : float = 0.02

#var modulate_tween : Tween
#var ratio_tween : Tween


@onready var text_field : Label = $Text
@onready var options_pool : VBoxContainer = $Buttons

func _ready() -> void:
	modulate = START_MODULATE
	
	


func dialogue_box_popin() -> void:
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", FINISH_MODULATE, MODULATION_TIME)
	modulate_tween.play()
	await modulate_tween.finished
	modulate = FINISH_MODULATE
	return


func dialogue_box_popout() -> void:
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", START_MODULATE, MODULATION_TIME)
	modulate_tween.play()
	await modulate_tween.finished
	modulate = START_MODULATE
	return


func text_typing(text : String) -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	var ratio_tween = create_tween()
	if text == null:
		print("Текст недоступен!!!")
	elif text == "":
		print("Получена пустая строка!")
	else:
		text_field.visible_ratio = START_RATIO
		text_field.text = text
		var typing_speed = text.length() * LETTER_SPEED
		ratio_tween.tween_property(text_field, "visible_ratio", FINISH_RATIO, typing_speed)
		ratio_tween.play()
		await ratio_tween.finished
		mouse_filter = MOUSE_FILTER_STOP
	return

func fill_options(data : Array) -> void:
	text_field.text = ""
	for item in data:
		var option : PackedScene = load(item)
		var child : Button = option.instantiate()
		options_pool.add_child(child)
		child.pressed.connect(on_option_pressed.bind(child))
		mouse_filter = MOUSE_FILTER_IGNORE
	return

func on_option_pressed(option: Button) -> void:
	if option.name == "Leave":
		dialogue_box_popout()
		mouse_filter = MOUSE_FILTER_IGNORE
		Signals.emit_signal("leave_option_clicked")
	else:
		var name : String = option.name
		Signals.emit_signal("new_line_requested", int(name))
	var option_buttons = options_pool.get_children()
	for button in option_buttons:
		button.queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Signals.emit_signal("dialogue_box_clicked")
