extends Node




var func_property : Callable


@onready var timer : Timer = $Timer
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		print("Вызов")
		if func_property:
			func_property.call()


func method_name():
	pass
