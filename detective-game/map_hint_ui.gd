extends CanvasLayer

func _ready():

	if PlayerInput.map_unlocked:
		show()
	else:
		hide()

	if SignalBus:
			SignalBus.map_unlocked.connect(show) 

func _on_dialogue_finished(_dialogue_data):
	if PlayerInput.map_unlocked:
		show()
