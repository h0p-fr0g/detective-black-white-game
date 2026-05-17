extends NPCBase

@export var late_dialogue: Dialogue


func _ready():
	if not GlobalFlags.desk_investigated or not GlobalFlags.picture_found:
		queue_free()
		return
		


func _on_interacted() -> void:
	GlobalFlags.location_store_unlocked = true
	
	if GlobalFlags.talked_to_clerk:
		if late_dialogue:
			print("Clerk-Flag ist aktiv! Wechsle zu Folgedialog.")
			$Interactable.dialogue = late_dialogue
		else:
			print("Warnung: Kein 'clerk_followup_dialogue' im Inspektor zugewiesen!")
	
	super._on_interacted()
