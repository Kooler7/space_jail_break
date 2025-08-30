extends Node2D

enum BuddyStates {
	ALIVE,
	DEAD_WITH_EYE,
	DEAD_NO_EYE
}

var current_buddy_state : BuddyStates = BuddyStates.ALIVE
#var current_buddy_node_path : String = "res://levels/chapter_1/interractional_objects/buddy_npc/buddy_nodes/buddy_alive_node/buddy_alive_node.tscn"
@export var buddy_alive : PackedScene


@onready var explaner : Label = $Explaner
@onready var mouse_detector : Area2D = $MouseDetector

func _ready() -> void:
	Signals.dialogue_completed.connect(toggle_pickable)

func check_buddy_states(new_state) -> void:
	match new_state:
		BuddyStates.ALIVE:
			#current_buddy_node_path = "res://levels/chapter_1/interractional_objects/buddy_npc/buddy_nodes/buddy_alive_node/buddy_alive_node.tscn"
			Signals.emit_signal("game_object_clicked", buddy_alive)
			current_buddy_state = BuddyStates.ALIVE
		BuddyStates.DEAD_WITH_EYE:
			#Signals.emit_signal("game_object_clicked", current_buddy_node_path)
			pass
		BuddyStates.DEAD_NO_EYE:
			#Signals.emit_signal("game_object_clicked", current_buddy_node_path)
			pass

func toggle_pickable() -> void:
	if mouse_detector.input_pickable:
		mouse_detector.input_pickable = false
	elif !mouse_detector.input_pickable:
		mouse_detector.input_pickable = true


func _on_mouse_detector_mouse_entered() -> void:
	explaner.popin()


func _on_mouse_detector_mouse_exited() -> void:
	explaner.popout()


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		explaner.popout()
		toggle_pickable()
		check_buddy_states(current_buddy_state)
