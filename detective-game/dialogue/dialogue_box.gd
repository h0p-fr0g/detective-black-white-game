extends TextureRect

func _ready() -> void:
	visible = false

func displayDialogue(dialogue: DialogueData):
	visible = true
	for entry in dialogue.dialogue_entries:
		$Portrait.texture = entry.character_sprite
		for line in entry.text:
			$Text.visible_characters = 0
			$Text.text = line
			for i in line.length():
				$Text.visible_characters = i + 1
				await get_tree().create_timer(0.03).timeout
			await get_tree().create_timer(1.5).timeout
	visible = false	
