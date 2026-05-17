extends CanvasLayer

var skipped = false

#TODO: dialogue options are hardcoded to 3 max! make more scalable
var a_pressed = false
var b_pressed = false
var c_pressed = false

var current_dialogue: Dialogue

@onready var portrait := $Box/Portrait
@onready var text := $Box/Text
@onready var option_a_button := $Box/OptionA
@onready var option_b_button := $Box/OptionB
@onready var option_c_button := $Box/OptionC

func _ready() -> void:
	SignalBus.dialogue_started.connect(_on_dialogue_started)
	option_a_button.visible = false
	option_b_button.visible = false
	option_c_button.visible = false
	visible = false


func _on_dialogue_started(dialogue: Dialogue):
	if visible:
		push_error("tried to start dialogue while dialogue is already active!")
		return
	
	current_dialogue = dialogue
	
	get_tree().paused = true
	visible = true

	await display_dialogue(dialogue)
	
	visible = false
	get_tree().paused = false
	
	if SignalBus:
		SignalBus.dialogue_finished.emit(current_dialogue)
	
	current_dialogue = null


func display_dialogue(dialogue: Dialogue):
	var entries = dialogue.dialogue_entries
	for entry in entries:
		await display_entry(entry)


func display_entry(entry: DialogueEntry):
	portrait.texture = entry.character_sprite
	for i in entry.text.size():	
		var line = entry.text[i] 
		text.visible_characters = 0
		text.text = line
		await display_line(line)
		
		if entry.choice and i == entry.text.size() - 1:
			await display_choice(entry)
			return
			
		while not skipped:
			await get_tree().process_frame
		skipped = false


func display_line(line: String):
	for i in line.length():
		text.visible_characters = i + 1
		await get_tree().create_timer(0.03).timeout
		
		if skipped:
			text.visible_characters = line.length()
			skipped = false
			return


func display_choice(entry: DialogueEntry):
	var options = entry.choice.options
	var nr_options = options.size()
	if nr_options > 3:
		push_error("dialogue with choice must have 3 options max!")
		return true
					
	#this is giving me nightmares
	a_pressed = false	
	var option_a = options[0]
	if not option_a.completed: 
		option_a_button.visible = true
		option_a_button.text = option_a.text
		
	b_pressed = false
	var option_b
	if nr_options > 1:
		option_b = options[1]
		if not option_b.completed:
			option_b_button.visible = true
			option_b_button.text = option_b.text
	
	c_pressed = false
	var option_c
	if nr_options > 2:
		option_c = options[2]
		if not option_c.completed:
			option_c_button.visible = true
			option_c_button.text = option_c.text
	
	while not a_pressed and not b_pressed and not c_pressed:
		await get_tree().process_frame
	
	option_a_button.visible = false
	option_b_button.visible = false
	option_c_button.visible = false

	skipped = false #is this necessary here?
	
	var chosen_option: DialogueOption = option_a if a_pressed else option_b if b_pressed else option_c	
	await display_dialogue(chosen_option.next_dialogue)
	
	if chosen_option.replace_with_option:
		#HORSESHIT
		if a_pressed:
			options[0] = chosen_option.replace_with_option
		elif b_pressed:
			options[1] = chosen_option.replace_with_option
		elif c_pressed:
			options[2] = chosen_option.replace_with_option
	else:
		chosen_option.completed = true
	
	if not chosen_option.complete_choice:
		await display_entry(entry)


func _input(p_input_event: InputEvent) -> void:
	if visible and p_input_event.is_action_pressed(&"skip_dialogue"):
		skipped = true


func _on_option_a_pressed() -> void:
	a_pressed = true


func _on_option_b_pressed() -> void:
	b_pressed = true


func _on_option_c_pressed() -> void:
	c_pressed = true
