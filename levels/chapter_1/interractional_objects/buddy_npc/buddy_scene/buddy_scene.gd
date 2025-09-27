#buddy_scene.gd
extends Node2D

enum BuddyStates {
	ALIVE,
	DEAD_WITH_EYE,
	DEAD_NO_EYE
}

var current_buddy_state : BuddyStates = BuddyStates.ALIVE

@export var buddy_alive : PackedScene



@onready var mouse_detector : Area2D = $MouseDetector



#func check_buddy_states(new_state) -> void:
	#match new_state:
		#BuddyStates.ALIVE:
			#Globals.player.on_game_object_clicked(buddy_alive)
			#current_buddy_state = BuddyStates.ALIVE
		#BuddyStates.DEAD_WITH_EYE:
			#pass
		#BuddyStates.DEAD_NO_EYE:
			#pass



func _on_mouse_detector_mouse_entered() -> void:
	Globals.player.explaner.text.text = self.name
	Globals.player.explaner.popin()


func _on_mouse_detector_mouse_exited() -> void:
	Globals.player.explaner.popout()


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.player.explaner.popout()
		Globals.player.mouse_shield.mouse_filter = Control.MOUSE_FILTER_STOP
		Globals.current_npc = self
		#check_buddy_states(current_buddy_state)
