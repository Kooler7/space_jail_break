extends Node


var global_flags = {}
var level_flags ={}
var inventory = []
var current_level = ""
var level_decisions = {}
var global_decisions = {
	"melon_saved" : false,
}

func _ready() -> void:
	level_flags = {}
	level_decisions = {}

#func set_flag(name: String, value):
	#if flags.has(name) and flags[name] == value:
		#return
	#flags[name] = value
	#emit_signal("flag_changed", name, value)
#
#func has_flag(name: String) -> bool:
	#return flags.get(name, false)

func add_item(item: String):
	if not item in inventory:
		inventory.append(item)
		emit_signal("inventory_changed", item, true)

func remove_item(item: String):
	if item in inventory:
		inventory.erase(item)
		emit_signal("inventory_changed", item, false)

func has_item(item: String) -> bool:
	return item in inventory

func record_level_decision(dialogue_id: String, choice_id: String):
	level_decisions[dialogue_id] = choice_id

func record_global_decision(dialogue_id: String, choice_id: String):
	global_decisions[dialogue_id] = choice_id

# Сигналы
signal flag_changed(flag_name: String, new_value)
signal inventory_changed(item: String, added: bool)
