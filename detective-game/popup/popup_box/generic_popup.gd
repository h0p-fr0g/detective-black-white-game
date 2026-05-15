extends CanvasLayer

@onready var title_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Heading
@onready var content_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Text
@onready var close_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button_Close

func _ready():
	SignalBus.popup_opened.connect(_on_popup_opened)

func _on_popup_opened(data: PopupData):
	get_tree().paused = true
	close_button.grab_focus()
	title_label.text = data.title
	content_label.text = data.text
	show()


func _on_button_close_pressed() -> void:
	get_tree().paused = false
	hide()
