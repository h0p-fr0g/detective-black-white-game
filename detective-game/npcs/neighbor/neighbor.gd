extends NPCBase

func _ready():
	if not GlobalFlags.crime_apartment_entered:
		queue_free()
		return
	
	super._ready()
