extends NPCBase

@export var late_dialogue: Dialogue


func _ready():
	super._ready()
	if not GlobalFlags.desk_investigated or not GlobalFlags.picture_found:
		queue_free()
		return
		


func _on_interacted() -> void:
	GlobalFlags.location_store_unlocked = true
	
	if GlobalFlags.talked_to_clerk:
		if late_dialogue:
			$Interactable.dialogue = late_dialogue
	
	super._on_interacted()



func _on_dialogue_finished(p_ended_dialogue: Dialogue) -> void:
	if p_ended_dialogue == late_dialogue:
		
		GlobalFlags.second_neighbor_dialogue_finished = true
