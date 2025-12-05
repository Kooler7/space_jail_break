extends PointLight2D

@onready var pause_timer : Timer = $PauseTimer
@onready var flash_timer : Timer = $FlashTimer

func _ready() -> void:
	calculate_pause()

func calculate_pause() -> void:
	pause_timer.wait_time = randi_range(5, 10)
	pause_timer.start()
	await  pause_timer.timeout
	var flash_counts = randi_range(3, 6)
	for i in range(flash_counts):
		flash_timer.wait_time = randf_range(0.2, 0.5)
		flash_timer.start()
		await flash_timer.timeout
		if visible:
			hide()
		else:
			show()
	show()
	calculate_pause()
