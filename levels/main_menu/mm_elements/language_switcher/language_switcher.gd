#language_switcher.gd
extends HBoxContainer

#Переменная для ресурса Группа Кнопок
@export var languages_buttons_group : ButtonGroup

#Проигрыватель для звука щелчка кнопки
@onready var button_click : AudioStreamPlayer2D = $ButtonClick

#Массив для хранения кнопок
var languages_buttons : Array

func _ready() -> void:
	#Подключение сигналов кнопок к функции
	languages_buttons = languages_buttons_group.get_buttons()
	languages_buttons.sort()
	for button in languages_buttons:
		button.toggled.connect(on_button_toggled.bind(button))
		var button_locale = Settings.languages_locales[button.name]
		if button_locale == Settings.current_locale:
			button.set_pressed_no_signal(true)

#Обработчик нажатия кнопки
func on_button_toggled(toggled_on : bool, button : TextureButton) -> void:
	button_click.play()
	Settings.set_language(Settings.languages_locales[button.name])
