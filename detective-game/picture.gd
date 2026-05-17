extends Node2D

@export var dialogue_before_invert: Dialogue
@export var dialogue_after_invert: Dialogue

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

	if event_step == 2:
		event_step = 0
		GlobalFlags.trigger_invert_shader(false)
		
		if SignalBus and SignalBus.dialogue_finished.is_connected(_on_dialogue_finished):
			SignalBus.dialogue_finished.disconnect(_on_dialogue_finished)
		
		queue_free()
