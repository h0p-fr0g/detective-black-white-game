extends Node

@export var map_scene: PackedScene

var last_scene_file_path: String
var map_unlocked: bool = true
var is_in_dialogue: bool = false

func _ready() -> void:
	if SignalBus:
		SignalBus.dialogue_started.connect(_on_dialogue_started)
		SignalBus.dialogue_finished.connect(_on_dialogue_finished)

func _input(p_input_event: InputEvent) -> void:
	if p_input_event.is_action_pressed(&"map"):
		if is_in_dialogue:
			return
			
		if not map_unlocked:
			return
			
		var scene = get_tree().current_scene
		if scene.scene_file_path == map_scene.resource_path:
			return
		
		last_scene_file_path = scene.scene_file_path
		get_tree().change_scene_to_packed(map_scene)	


func _on_dialogue_started(_dialogue_data: Dialogue) -> void:
	is_in_dialogue = true

func _on_dialogue_finished(_dialogue_data: Dialogue) -> void:
	is_in_dialogue = false
