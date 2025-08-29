extends Sprite2D

enum NpcActionsStates {
	IDLE,
	TALKING,
	EXPLANING,
	INTERRACTING
}
var current_action_state : NpcActionsStates = NpcActionsStates.IDLE

var is_alive : bool = true


var npc_data : Dictionary = {
	"name" : "TestNPC"
}
#var current_dialogue_line : String
#var current_dialogue_key : int = 0

var npc_dialogue : Dictionary = {
	1 : "Player:Да уж, чуваку досталось... Все портроха наружу, блин.",
	2 : "Npc:Это ты, Змей? Что-то мне, кореш, не фортануло... Вовремя ты отлить встал...",
	3 : [
		"res://levels/chapter_1/dialogues/options/how_to_help.tscn",
		"res://levels/chapter_1/dialogues/options/leave.tscn"
	],
	4 : "Npc:Найди мне обезбола, а то чего-то совсем кисло..."
}

@onready var detection_area : Area2D = $Area2D
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	Signals.dialogue_completed.connect(check_npc_actions_states.bind(NpcActionsStates.IDLE))

func check_npc_actions_states(new_state) -> void:
	match new_state:
		NpcActionsStates.IDLE:
			if current_action_state == NpcActionsStates.EXPLANING:
				Signals.emit_signal("game_object_became_idle", npc_data)
				current_action_state = NpcActionsStates.IDLE
			elif current_action_state == NpcActionsStates.TALKING:
				current_action_state = NpcActionsStates.IDLE
				Signals.emit_signal("game_object_became_idle", npc_data)
				detection_area.input_pickable = true
		NpcActionsStates.TALKING:
			if current_action_state == NpcActionsStates.EXPLANING:
				Signals.emit_signal("npc_became_talk", npc_dialogue)
				current_action_state = NpcActionsStates.TALKING
		NpcActionsStates.EXPLANING:
			if current_action_state == NpcActionsStates.IDLE:
				Signals.emit_signal("game_object_became_explane", npc_data)
				current_action_state = NpcActionsStates.EXPLANING


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		detection_area.input_pickable = false
		check_npc_actions_states(NpcActionsStates.TALKING)

func _on_area_2d_mouse_entered() -> void:
	check_npc_actions_states(NpcActionsStates.EXPLANING)

func _on_area_2d_mouse_exited() -> void:
	if current_action_state != NpcActionsStates.TALKING:
		check_npc_actions_states(NpcActionsStates.IDLE)
	
