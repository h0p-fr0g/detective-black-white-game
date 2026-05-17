extends NPCBase


func _ready():
	if not GlobalFlags.desk_investigated or not GlobalFlags.picture_found:
		queue_free()
		return
		


func _on_interacted() -> void:
	GlobalFlags.location_store_unlocked = true
	super._on_interacted()
