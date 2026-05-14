extends CanvasLayer

var skipped = false

func _ready() -> void:
	SignalBus.dialogue_started.connect(_on_dialogue_started)
	visible = false

func _on_dialogue_started(dialogue: DialogueData):
	if visible:
		push_error("tried to start dialogue while dialogue is already active!")
		return
	
	get_tree().paused = true
	visible = true
	for entry in dialogue.dialogue_entries:
		$Portrait.texture = entry.character_sprite
		for line in entry.text:
			$Text.visible_characters = 0
			$Text.text = line
			await displayLine(line)
			while not skipped:
				await get_tree().process_frame
			skipped = false
			
	visible = false	
	get_tree().paused = false

func displayLine(line: String):
	for i in line.length():
		$Text.visible_characters = i + 1
		await get_tree().create_timer(0.03).timeout
		
		if skipped:
			$Text.visible_characters = line.length()
			skipped = false
			return

func _input(p_input_event: InputEvent) -> void:
	if visible and p_input_event.is_action_pressed(&"skip_dialogue"):
		skipped = true
