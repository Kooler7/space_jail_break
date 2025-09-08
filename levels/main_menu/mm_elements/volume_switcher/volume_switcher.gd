extends HBoxContainer

@onready var button_click : AudioStreamPlayer2D = $ButtonClick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_plus_volume_button_down() -> void:
	button_click.play()


func _on_minus_volume_button_down() -> void:
	button_click.play()
