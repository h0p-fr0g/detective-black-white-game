extends Node2D

func _on_interactable_interacted() -> void:
	GlobalFlags.picture_found = true;
