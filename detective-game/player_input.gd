extends Node

@export var map_scene: PackedScene

@export var example_dialogue: DialogueData

func _input(p_input_event: InputEvent) -> void:
	if p_input_event.is_action_pressed(&"map"):
		get_tree().change_scene_to_packed(map_scene)	
		
	if p_input_event.is_action_pressed(&"dialogue"): 
		print($DialogueBox.visible)
		if not $DialogueBox.visible:
			$DialogueBox.displayDialogue(example_dialogue)
