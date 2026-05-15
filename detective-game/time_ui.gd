extends CanvasLayer

func _on_day_night_button_pressed():
	var shader_rect = get_tree().root.find_child("DayNightShader", true, false)
	
	if shader_rect:
		var mat = shader_rect.material
		
		if mat is ShaderMaterial:
			var current = mat.get_shader_parameter("invert_amount")
			var new_value = 1.0 if current < 0.5 else 0.0
			mat.set_shader_parameter("invert_amount", new_value)
