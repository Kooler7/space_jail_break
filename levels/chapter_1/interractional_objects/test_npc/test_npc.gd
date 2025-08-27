extends Sprite2D



var trasfered_data : Dictionary
var line_1 : String = "Это ты, Змей? Что-то мне, кореш, не фортануло..."


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("CLICK!")
		trasfered_data = {"dialogue_text" : line_1}
		Signals.emit_signal("npc_mouse_clicked", trasfered_data)


func _on_area_2d_mouse_entered() -> void:
	trasfered_data = {"name" : name}
	Signals.emit_signal("game_object_mouse_entered", trasfered_data)


func _on_area_2d_mouse_exited() -> void:
	Signals.emit_signal("game_object_mouse_exited", trasfered_data)
