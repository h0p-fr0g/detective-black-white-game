extends TextureButton

@export var scene : PackedScene

@onready var original_scale := scale

func _ready() -> void:
	$Label.text = name
	
	_check_if_unlocked()
	if not disabled and scene:
		if PlayerInput.last_scene_file_path == scene.resource_path:
			grab_focus()

func _process(delta) -> void:
	if disabled:
		scale = original_scale
		return
		
	var target = original_scale * (1.2 if has_focus() or is_hovered() else 1.0)
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
