extends TextureButton

@export var scene : PackedScene

func _ready() -> void:
	$Label.text = name
	
	_check_if_unlocked()
	if not disabled and scene:
		if PlayerInput.last_scene_file_path == scene.resource_path:
			grab_focus()

func _process(delta) -> void:
	if disabled:
		scale = Vector2.ONE
		return
		
	var target = Vector2(1.2, 1.2) if has_focus() or is_hovered() else Vector2.ONE
	scale = scale.lerp(target, delta * 10)
	
func _on_pressed() -> void:
	if disabled:
		return
		
	print("changing scene to: ", name)
	get_tree().change_scene_to_packed(scene)

func _check_if_unlocked() -> void:
	match name:
		"My Office":
			disabled = not GlobalFlags.location_office_unlocked
		"Bar":
			disabled = not GlobalFlags.location_bar_unlocked
		"Store":
			disabled = not GlobalFlags.location_store_unlocked
		"Apartments":
			disabled = not GlobalFlags.location_apartments_unlocked

	if disabled:
		modulate = Color(0.4, 0.4, 0.4, 1.0) 
	else:
		modulate = Color.WHITE
