extends Node

@export var map_scene: PackedScene
@export var example_dialogue: DialogueData

var last_scene_file_path: String
var map_unlocked: bool = false

func _input(p_input_event: InputEvent) -> void:
	if p_input_event.is_action_pressed(&"map"):
		if not map_unlocked:
			return
			
		var scene = get_tree().current_scene
		if scene.scene_file_path == map_scene.resource_path:
			return
		
		last_scene_file_path = scene.scene_file_path
		get_tree().change_scene_to_packed(map_scene)	
		
	if p_input_event.is_action_pressed(&"dialogue"): 
		SignalBus.dialogue_started.emit(example_dialogue)
