extends NPCBase

func _ready():
	if not GlobalFlags.desk_investigated or not GlobalFlags.picture_found:
		queue_free()
		return
	
	super._ready()
