extends Node

#Этапы повествования
var global_flags = {}
var level_flags ={}

#Выбор сделанный на каком-то этапе повествования
var level_decisions = {}
var global_decisions = {
	"melon_saved" : false,
}

#Инвентарь
var inventory = []

#Текущий уровень игры
var current_level = ""


func _ready() -> void:
	level_flags = {}
	level_decisions = {}

func set_flag(flags: Dictionary, name: String, value: bool):
	if has_flag(flags, name):
		if flags.has(name) and flags[name] == value:
			return
		flags[name] = value
		emit_signal("flag_changed", name, value)

func get_flag_value(flags: Dictionary, name: String) -> bool:
	if has_flag(flags, name):
		return flags[name]
	return false

func has_flag(flags: Dictionary, name: String) -> bool:
	if flags.has(name):
		return true
	print("Нет флага " + name + "в словаре")
	return false

func add_item(item: String):
	if inventory.has(item) == false:
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
