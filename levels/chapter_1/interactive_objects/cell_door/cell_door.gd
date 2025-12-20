#cell_door.gd
extends InteractiveObject

#Состояния двери
enum DoorStates {
	CLOSED,
	OPENED
}
var _current_door_state : DoorStates = DoorStates.CLOSED


func _ready() -> void:
	#Подключение сигнала изменения этапа уровня к функции изменения состояния двери
	GameState.flag_changed.connect(_check_door_state.bind(DoorStates.OPENED))
	#Получение всех возможных диалогов
	_dialogues = $Dialogues.get_children()


#Обработка клика мыши на объекте
func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released() and event.\
																button_index == MOUSE_BUTTON_LEFT:
		Globals.set_current_object(self)
		DialogueManager.set_dialogue_tree()
		DialogueManager.start_dialogue()



#Изменение состояния двери
func _check_door_state(flag_name: String, flag_value: bool, new_state: DoorStates) -> void:
	if flag_name == "door_open" and flag_value == true:
		match new_state:
			DoorStates.CLOSED:
				_current_door_state = DoorStates.CLOSED
				icon.show()
			DoorStates.OPENED:
				_current_door_state = DoorStates.OPENED
				icon.hide()
