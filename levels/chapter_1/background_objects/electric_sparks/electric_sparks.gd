extends Node2D

@onready var light : PointLight2D = $Light
@onready var sparks : GPUParticles2D = $GPUParticles2D
@onready var emission_timer : Timer = $EmissionTimer
@onready var flash_timer : Timer = $FlashTimer
@onready var sparks_sound : AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_sparks()

#func _process(delta: float) -> void:
	#if sparks.emitting:
		#print("FLASH!!!")
		#light.energy = 1
		#await get_tree().process_frame
		#await get_tree().process_frame
		#light.energy = 0
		#print("STOP!!!")

func emit_sparks() -> void:
	emission_timer.wait_time = randi_range(1, 3)
	emission_timer.start()
	await  emission_timer.timeout
	sparks.emitting = true
	
	light.show()
	flash_light()
	await sparks.finished

	light.hide()
	emit_sparks()

func flash_light() -> void:
	light.enabled = true
	print(light.enabled)
	flash_timer.start()
	sparks_sound.play()
	await flash_timer.timeout
	light.enabled = false
	print(light.enabled)
	if sparks.emitting:
		flash_light()
	else:
		sparks_sound.stop()
		return 
