extends Node

var phone_should_ring: bool = true
var files_searched: bool = false
var crime_apartment_entered: bool = false
var first_time_in_apartments: bool = true
var desk_investigated: bool = false
var picture_found: bool = false

#Locations
var location_office_unlocked: bool = true 
var location_bar_unlocked: bool = false
var location_store_unlocked: bool = false
var location_apartments_unlocked: bool = true



func trigger_invert_shader(enable: bool) -> void:
	var shader_rect = get_tree().root.find_child("DayNightShader", true, false)
	
	if shader_rect:
		var mat = shader_rect.material
		if mat is ShaderMaterial:
			# HIER DIE KORREKTUR: Wir nutzen direkt das 'enable'!
			# Wenn true -> 1.0, wenn false -> 0.0. Kein Togglen mehr!
			var new_value = 1.0 if enable else 0.0
			mat.set_shader_parameter("invert_amount", new_value)
			print("Shader auf ", new_value, " gesetzt (erzwungen durch Parameter).")
	else:
		print("Fehler: DayNightShader wurde nicht gefunden!")
