extends Node2D

@export var dialogue_before_invert: Dialogue
@export var dialogue_after_invert: Dialogue
@export var ending_dialogue: Dialogue

var event_step: int = 0
var was_already_interacted: bool = false

func _ready() -> void:
	if SignalBus:
		SignalBus.dialogue_finished.connect(_on_dialogue_finished)

func _on_interactable_interacted() -> void:
	if event_step > 0 or was_already_interacted:
		return
		
	was_already_interacted = true
	GlobalFlags.picture_found = true
	
	if dialogue_before_invert:
		event_step = 1
		SignalBus.dialogue_started.emit(dialogue_before_invert)


func _on_dialogue_finished(p_ended_dialogue: Dialogue) -> void:
	# SCHRITT 1 ENDET: Dialog 1 vorbei -> Shader AN, Dialog 2 START
	if event_step == 1:
		event_step = 2
		GlobalFlags.trigger_invert_shader(true)
		
		if dialogue_after_invert:
			await get_tree().process_frame
			SignalBus.dialogue_started.emit(dialogue_after_invert)
		else:
			event_step = 0
			GlobalFlags.trigger_invert_shader(false)
		return

	# SCHRITT 2 ENDET: Dialog 2 vorbei -> Shader AUS, Dialog 3 START
	if event_step == 2:
		event_step = 3 # Wir wechseln zu Schritt 3
		GlobalFlags.trigger_invert_shader(false) # Bildschirm wieder normal machen
		
		if ending_dialogue:
			await get_tree().process_frame
			SignalBus.dialogue_started.emit(ending_dialogue)
		else:
			# Falls kein dritter Dialog drin ist, direkt aufräumen
			_clean_up()
		return

	# SCHRITT 3 ENDET: Dialog 3 vorbei -> Bild einsammeln!
	if event_step == 3:
		_clean_up()


# Kleine Hilfsfunktion, um doppelten Code beim Löschen zu vermeiden
func _clean_up() -> void:
	event_step = 0
	if SignalBus and SignalBus.dialogue_finished.is_connected(_on_dialogue_finished):
		SignalBus.dialogue_finished.disconnect(_on_dialogue_finished)
	queue_free()
