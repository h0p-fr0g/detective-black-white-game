extends CanvasLayer

var skipped = false
var a_pressed = false
var b_pressed = false

@onready var portrait := $Box/Portrait
@onready var text := $Box/Text
@onready var option_a_text := $Box/OptionA
@onready var option_b_text := $Box/OptionB

func _ready() -> void:
	SignalBus.dialogue_started.connect(_on_dialogue_started)
	option_a_text.visible = false
	option_b_text.visible = false
	visible = false


func _on_dialogue_started(dialogue: DialogueData):
	if visible:
		push_error("tried to start dialogue while dialogue is already active!")
		return
	
	get_tree().paused = true
	visible = true
	var entries = dialogue.dialogue_entries
	for i in entries.size():
		var entry = entries[i]
		portrait.texture = entry.character_sprite
		for a in entry.text.size():
			var line  = entry.text[a]
			
			text.visible_characters = 0
			text.text = line
			await displayLine(line)
			
			if dialogue.choices and i == entries.size() - 1 and a == entry.text.size() - 1:
				if not dialogue.choices.size() == 2:
					push_error("dialogue with choice must have exactly 2 options!")
					return
				
				print("choice")
				var option_a = dialogue.choices[0]
				var option_b = dialogue.choices[1]
				option_a_text.visible = true
				option_b_text.visible = true
				a_pressed = false
				b_pressed = false
				option_a_text.text = option_a.text
				option_b_text.text = option_b.text
				
				while not a_pressed and not b_pressed:
					await get_tree().process_frame
				
				option_a_text.visible = false
				option_b_text.visible = false
				visible = false
				get_tree().paused = false
				
				SignalBus.dialogue_started.emit(option_a.next_dialogue if a_pressed else option_b.next_dialogue)
				return
			
			while not skipped:
				await get_tree().process_frame
			skipped = false
			
	visible = false	
	get_tree().paused = false


func displayLine(line: String):
	for i in line.length():
		text.visible_characters = i + 1
		await get_tree().create_timer(0.03).timeout
		
		if skipped:
			text.visible_characters = line.length()
			skipped = false
			return


func _input(p_input_event: InputEvent) -> void:
	if visible and p_input_event.is_action_pressed(&"skip_dialogue"):
		skipped = true


func _on_option_a_pressed() -> void:
	a_pressed = true


func _on_option_b_pressed() -> void:
	b_pressed = true
