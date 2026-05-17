extends Node

@export_file("res://*.tscn") var target_scene: String
@export var missing_clues_dialogue: Dialogue

func _on_interacted() -> void:
	if GlobalFlags.desk_investigated and GlobalFlags.picture_found:
		get_tree().change_scene_to_file(target_scene)
	else:
		if missing_clues_dialogue:
			SignalBus.dialogue_started.emit(missing_clues_dialogue)
