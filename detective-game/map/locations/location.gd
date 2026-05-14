extends TextureButton

@export var scene : PackedScene

func _process(delta):
	var target = Vector2(1.2, 1.2) if has_focus() or is_hovered() else Vector2.ONE
	scale = scale.lerp(target, delta * 10)
	
func _on_pressed() -> void:
	print("changing scene")
	get_tree().change_scene_to_packed(scene)
