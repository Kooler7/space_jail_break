extends Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("CLICK!")
		Signals.emit_signal("test_npc_mouse_clicked")



func _on_area_2d_mouse_entered() -> void:
	Signals.emit_signal("test_npc_mouse_entered")


func _on_area_2d_mouse_exited() -> void:
	Signals.emit_signal("test_npc_mouse_exited")
