extends Node2D

@onready var pipe : AnimatedSprite2D = $Pipe
@onready var door : Sprite2D = $Door
@onready var death_timer : Timer = $Timer
@onready var diargam : Sprite2D = $Force
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_game_started() -> void:
	pass

func on_game_finished() -> void:
	pass
