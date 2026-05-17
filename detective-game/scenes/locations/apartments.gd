extends Node2D

@export var first_visit_monologue: Dialogue

func _ready() -> void:
	if GlobalFlags.first_time_in_apartments:
		GlobalFlags.first_time_in_apartments = false
		
		await get_tree().process_frame
		
		if first_visit_monologue:
			SignalBus.dialogue_started.emit(first_visit_monologue)
