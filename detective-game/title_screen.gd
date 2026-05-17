extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/locations/office.tscn")

func _on_credits_button_pressed() -> void:
	$Label.visible = true;
