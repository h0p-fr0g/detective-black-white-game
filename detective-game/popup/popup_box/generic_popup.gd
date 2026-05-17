extends CanvasLayer

@onready var close_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button_Close
@onready var image = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TextureRect


func _ready():
	hide()
	SignalBus.popup_opened.connect(_on_popup_opened)


func _on_popup_opened(data: PopupData):
	get_tree().paused = true
	show()
	
	if not close_button:
		close_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button_Close
		
	if close_button:
		close_button.grab_focus()


func _on_button_close_pressed() -> void:
	if SignalBus:
		SignalBus.popup_closed.emit()
		
	get_tree().paused = false
	hide()
