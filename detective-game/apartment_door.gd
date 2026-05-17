extends Node

@export var scene: PackedScene

func _on_interacted() -> void:
	GlobalFlags.crime_apartment_entered = true
	get_tree().change_scene_to_packed(scene)
