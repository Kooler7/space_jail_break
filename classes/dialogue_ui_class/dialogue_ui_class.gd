#dialogue_ui_class.gd
class_name DialogueUI
extends CanvasLayer


const DialogueBox = preload("res://GUI/dialogue_box/dialogue_box.gd")

var _speakers : Array
var _current_speaker : CharacterAvatarClass
var dialodue_box_update : Callable
var dialogue_box_states = null

@onready var dialogue_box : DialogueBox = $DialogueBox
@onready var avatar_position : Marker2D = $AvatarPosition


func _ready() -> void:
	Globals.set_dialogue_ui(self)
	DialogueManager.dialogue_ui = self
	_speakers = avatar_position.get_children()
	dialodue_box_update = dialogue_box.update_visibility_state
	dialogue_box_states = dialogue_box.VisibilityStates
	scale.x = Settings.camera.zoom.x
	scale.y = Settings.camera.zoom.y

func set_text(new_text: String) -> void:
	dialogue_box.text = new_text

func set_options(new_options: Array) -> void:
	dialogue_box.options = new_options


#Функция управления показом автвров говорящих
func toggle_speaker_avatar(speaker_name : String = "", finish_dialogue : bool = false) -> void:
	if finish_dialogue:
		await _current_speaker.popout()
		_current_speaker = null
		return
	for speaker in _speakers:
		if speaker.name == speaker_name:
			if _current_speaker == null:
				_current_speaker = speaker
				await _current_speaker.popin()
				return
			elif _current_speaker != null:
				await _current_speaker.popout()
				_current_speaker = speaker
				await _current_speaker.popin()
				return
