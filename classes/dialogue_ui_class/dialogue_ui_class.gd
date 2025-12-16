#dialogue_ui_class.gd
class_name DialogueUI
extends CanvasLayer

const DialogueBox = preload("res://GUI/dialogue_box/dialogue_box.gd")
var speakers : Array
var current_speaker : CharacterAvatarClass

@onready var dialogue_box : DialogueBox = $DialogueBox
@onready var avatar_position : Marker2D = $AvatarPosition


func _ready() -> void:
	Globals.dialogue_ui = self
	DialogueManager.dialogue_ui = self
	speakers = avatar_position.get_children()
	scale.x = Settings.camera.zoom.x
	scale.y = Settings.camera.zoom.y



#Функция управления показом автвров говорящих
func toggle_speaker_avatar(speaker_name : String = "", finish_dialogue : bool = false) -> void:
	if finish_dialogue:
		await current_speaker.popout()
		current_speaker = null
		return
	for speaker in speakers:
		if speaker.name == speaker_name:
			if current_speaker == null:
				current_speaker = speaker
				await current_speaker.popin()
				return
			elif current_speaker != null:
				await current_speaker.popout()
				current_speaker = speaker
				await current_speaker.popin()
				return
