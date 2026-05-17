extends NPCBase

func _on_interacted() -> void:
	GlobalFlags.talked_to_clerk = true
	super._on_interacted()
