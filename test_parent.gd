extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Test_Child.func_property = test_print_1
	print($Test_Child.func_property)


func test_print():
	print("CHILD_PRINTING")

func test_print_1():
	print("CHILD_PRINTING_1")
