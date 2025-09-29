extends HBoxContainer

@onready var button_click : AudioStreamPlayer2D = $ButtonClick
@onready var progress_bar : TextureProgressBar = $TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = Settings.current_global_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#progress_bar.value = Settings.current_global_volume


func _on_plus_volume_button_down() -> void:
	if progress_bar.value >= progress_bar.max_value:
		progress_bar.value = progress_bar.max_value
	elif progress_bar.value < progress_bar.max_value:
		progress_bar.value = progress_bar.value + progress_bar.step
		Settings.current_global_volume = progress_bar.value
		Settings.set_global_volume(Settings.current_global_volume)
	button_click.play()


func _on_minus_volume_button_down() -> void:
	if progress_bar.value <= progress_bar.min_value:
		progress_bar.value = progress_bar.min_value
	elif progress_bar.value > progress_bar.min_value:
		progress_bar.value = progress_bar.value - progress_bar.step
		Settings.current_global_volume = progress_bar.value
		Settings.set_global_volume(Settings.current_global_volume)
	button_click.play()
