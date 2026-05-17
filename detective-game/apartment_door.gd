extends Node

@export_file("res://*.tscn") var target_scene: String
@export var tooltip: String
@export var missing_phone_call: Dialogue
@export var missing_files: Dialogue

func _ready():
	$Interactable.tooltip_text = tooltip

func _on_interacted() -> void:
	if missing_phone_call and missing_files:
		if(GlobalFlags.phone_should_ring):
			SignalBus.dialogue_started.emit(missing_phone_call)
		elif(not GlobalFlags.files_searched):
			SignalBus.dialogue_started.emit(missing_files)
		else:
			get_tree().change_scene_to_file(target_scene)
		return
	

	get_tree().change_scene_to_file(target_scene)
